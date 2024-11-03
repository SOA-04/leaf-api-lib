# frozen_string_literal: true

require_relative '../domain/session/entities/session'

module Leaf
  # This is a class to represent the concept of SessionController.
  class SessionController
    def initialize(session)
      @session = session
      @session[:trip] ||= Leaf::Session.new
    end

    def set_trip(origin, destination, strategy)
      trip = @session[:trip]
      trip.set_trip(origin, destination, strategy)
      "Location set: #{trip}"
    end

    def user_origin
      @session[:trip].origin
    end

    def user_destination
      @session[:trip].destination
    end

    def user_strategy
      @session[:trip].strategy
    end

    def user_route
      @session[:trip].route_info
    end

    def end_session
      if session_exists?
        @session[:trip]&.clear
        @session.delete(:trip)
        'Session ended.'
      else
        'No session data to clear.'
      end
    end

    def session_exists?
      trip = @session[:trip]
      trip&.origin && trip&.destination && trip&.strategy
    end
  end
end
