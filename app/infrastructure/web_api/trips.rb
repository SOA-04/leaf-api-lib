# frozen_string_literal: true

require 'http'
require 'json'
require_relative '../utils'

module Leaf
  module WebAPI
    # This is the gateway class to make API requests to our backend API.
    # The endpoint will be determined by the provided environmental variable
    class Trip
      def initialize(endpoint)
        @http = HTTP.accept(:json).persistent(endpoint)
      end

      def get_trip(id)
        response = @http.get("/trip/#{id}")

        Response.new(response).handle_error("by WebAPI::Query::Get, status: #{response.status}")
      end

      # Given 2 points and the travel strategy, obtain the distance and travel time.
      # Refer to: https://developers.google.com/maps/documentation/distance-matrix/distance-matrix
      # @param  origin      [String]  Can be addresses or coordinate.
      # @param  destination [String]  Can be addresses or coordinate.
      # @option strategy    [String]  Possible values are ['driving', 'walking', 'transit', 'bicycling']
      def create_trip(origin, destination, strategy = 'walking')
        response = @http.post('/trips', json: {
                                destination: destination,
                                origin: origin,
                                strategy: strategy
                              })

        Response.new(response).handle_error("by WebAPI::Trip::Create, status: #{response.status}")
      end
    end
  end
end
