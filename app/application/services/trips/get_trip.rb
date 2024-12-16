# frozen_string_literal: true

require 'securerandom'
require 'ostruct'
require 'dry/transaction'
require_relative '../../../infrastructure/web_api/trips'
require_relative '../../representers/trip'

module Leaf
  module Service
    # :reek:FeatureEnvy
    # :reek:UncommunicativeVariableName
    class GetTrip
      include Dry::Transaction

      step :fetch
      step :parse_object

      private

      def fetch(input)
        result = Leaf::WebAPI::Trip.new(App.config.API_URL).get_trip(input)

        Success(result)
      rescue StandardError => e
        Failure("Calling API: #{e}")
      end

      def parse_object(input)
        result = Representer::Trip.new(OpenStruct.new).from_hash(input)
        Success(result)
      rescue StandardError => e
        Failure("Parsing response for Trip: #{e}")
      end
    end
  end
end
