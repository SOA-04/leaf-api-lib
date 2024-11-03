# frozen_string_literal: true

require_relative '../../infrastructure/google_maps/mappers/trip_mapper'
require_relative '../../infrastructure/google_maps/gateways/google_maps_api'
require_relative '../../../config/environment'
require_relative '../session_controller'

module Leaf
  # Module handling trip-related routes
  module TripRoutes
    def self.setup(routing)
      routing.on 'trips' do
        setup_trip_submit(routing)
        setup_trip_form(routing)
        setup_trip_result(routing)
        setup_sessin(routing)
      end
    end

    def setup_sessin(routing)
      setup_trip_check(routing)
      setup_end_session(routing)
    end

    def self.setup_trip_submit(routing)
      routing.post 'submit' do
        params = routing.params
        origin = params['origin']
        destination = params['destination']
        strategy = params['strategy']

        session_controller = SessionController.new(routing.session)
        session_controller.set_trip(origin, destination, strategy)

        routing.redirect "#{origin}/#{destination}/#{strategy}"
      end
    end

    def self.setup_trip_form(routing)
      routing.is do
        routing.get do
          routing.scope.view 'trip_form'
        end
      end
    end

    def self.setup_trip_result(routing)
      routing.on String, String, String do |origin, destination, strategy|
        session_controller = SessionController.new(routing.session)

        routing.get do
          params = { origin: origin, destination: destination, strategy: strategy }
          trip_params = build_trip_params(session_controller, params)
          trip = find_trip(trip_params)
          routing.scope.view('trip_result', locals: { trip: trip })
        end
      end
    end

    def self.setup_trip_check(routing)
      routing.get 'check' do
        session_controller = SessionController.new(routing.session)
        session_controller.user_route
      end
    end

    def self.setup_end_session(routing)
      routing.delete 'end_session' do
        session_controller = SessionController.new(routing.session)
        session_controller.end_session
      end
    end

    def self.build_trip_params(session_controller, params = {})
      {
        origin: session_controller.user_origin || params[:origin],
        destination: session_controller.user_destination || params[:destination],
        strategy: session_controller.user_strategy || params[:strategy]
      }
    end

    def self.find_trip(trip_params)
      trip_params[:origin] ||= '24.795707, 120.996393'
      trip_params[:destination] ||= '24.786930, 120.988428'
      trip_params[:strategy] ||= 'walking'

      trip_entities(trip_params)
    end

    def self.trip_entities(trip_params)
      mapper = Leaf::GoogleMaps::TripMapper.new(
        Leaf::GoogleMaps::API,
        Leaf::App.config.GOOGLE_TOKEN
      )

      mapper.find(
        CGI.unescape(trip_params[:origin]),
        CGI.unescape(trip_params[:destination]),
        CGI.unescape(trip_params[:strategy])
      )
    end
  end
end
