# frozen_string_literal: true

require 'ostruct'
require 'dry/transaction'
require_relative '../../../infrastructure/web_api/locations'
require_relative '../../representers/location'

module Leaf
  module Service
    # :reek:FeatureEnvy
    # :reek:UncommunicativeVariableName
    class GetLocation
      include Dry::Transaction

      step :fetch
      step :parse_object

      private

      # Fetch location data from the API
      def fetch(plus_code)
        result = Leaf::WebAPI::Locations.new(App.config.API_URL).find(plus_code)

        Success(result)
      rescue StandardError => e
        Failure("Calling API: #{e}")
      end

      # Parse the fetched data into an internal structure
      def parse_object(input)
        result = Representer::Location.new(OpenStruct.new).from_hash(input)
        Success(result)
      rescue StandardError => e
        Failure("Parsing response for Location::Get : #{e}")
      end
    end
  end
end
