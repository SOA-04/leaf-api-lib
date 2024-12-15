# frozen_string_literal: true

require 'securerandom'
require 'dry/transaction'
require_relative '../../../infrastructure/web_api/trips'

module Leaf
  module Service
    # :reek:FeatureEnvy
    # :reek:UncommunicativeVariableName
    class AddTrip
      include Dry::Transaction

      step :validate_input
      step :call_api

      private

      def validate_input(input)
        if input.success?
          Success(origin: input[:origin], destination: input[:destination], strategy: input[:strategy])
        else
          Failure("Invalid input: #{input.errors.messages.first}")
        end
      end

      def call_api(input)
        result = WebAPI::Trip.new(App.config.API_URL).create_trip(
          input[:origin], input[:destination], input[:strategy]
        )

        Success(id: result['id'])
      rescue StandardError => e
        Failure("API Error: #{e}")
      end
    end
  end
end
