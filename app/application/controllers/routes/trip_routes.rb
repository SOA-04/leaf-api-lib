# frozen_string_literal: true

require 'securerandom'
require_relative '../../../../config/environment'
require_relative '../../../presentation/view_objects/trip'
require_relative '../../forms/new_trip'
require_relative '../../services/trips/add_trip'
require_relative '../../services/trips/get_trip'

module Leaf
  # Application
  class App < Roda
    plugin :multi_route
    plugin :flash

    route('trips') do |routing| # rubocop:disable Metrics/BlockLength
      routing.post 'submit' do
        trip_request = Forms::NewTrip.new.call(routing.params)
        trip_result = Service::AddTrip.new.call(trip_request)
        # binding.irb

        if trip_result.failure?
          puts(trip_result.failure)
          flash[:error] = trip_result.failure
          routing.redirect '/trips'
        end

        trip_id = trip_result.value!
        routing.session[:visited_trip] ||= []
        routing.session[:visited_trip].insert(0, trip_id[:id]).uniq!
        flash[:notice] = "Trip #{trip_id[:id]} created."
        routing.redirect trip_id[:id]
      end

      routing.is do
        routing.get do
          routing.scope.view 'trips/trip_form'
        end
      end

      routing.on String do |trip_id|
        routing.get do
          trip = Service::GetTrip.new.call(trip_id)

          if trip.failure?
            puts(trip.failure)
            flash[:error] = trip_result.failure
            routing.redirect '/trips'
          end

          trip_view = Views::Trip.new(trip.value!)
          routing.scope.view('trips/trip_result', locals: { trip: trip_view })
        end
        routing.delete do
          routing.session[:visited_trip].delete(trip_id)
          flash[:notice] = "Trip '#{trip_id}' has been removed from history."
          routing.redirect '/trips'
        end
      end
    end
  end
end
