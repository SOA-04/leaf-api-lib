# frozen_string_literal: true

require 'http'
require 'json'
require_relative '../utils'

module Leaf
  module WebAPI
    class Locations
      def initialize(endpoint)
        @http = HTTP.accept(:json).persistent(endpoint)
      end

      # Create a new location
      def create(location_name)
        response = @http.post('/locations', json: { location: location_name })
        # binding.irb
        Response.new(response).handle_error("by WebAPI::Location::Add, status: #{response.status}")
        # handle_response(response)
      end

      # Find a specific location
      def find(plus_code)
        encoded_name = CGI.escape(plus_code)
        response = @http.get("/locations/#{encoded_name}")
        Response.new(response).handle_error("by WebAPI::Location::Get, status: #{response.status}")
        # handle_response(response)
      end

      private

      def handle_response(response)
        unless response.status.success?
          raise StandardError, "API Error: #{response.status} - #{response.parse['message']}"
        end

        response.parse
      end
    end
  end
end
