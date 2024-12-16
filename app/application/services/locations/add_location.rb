# frozen_string_literal: true

require 'dry/transaction'
require_relative '../../../infrastructure/web_api/locations'

module Leaf
  module Service
    # :reek:FeatureEnvy
    # :reek:UncommunicativeVariableName
    class AddLocation
      include Dry::Transaction

      step :validate_input
      step :call_api

      private

      def validate_input(input)
        if input.success?
          Success(location: input[:location])
        else
          Failure("Invalid input: #{input.errors.messages.first}")
        end
      end

      def call_api(input)
        result = Leaf::WebAPI::Locations.new(App.config.API_URL).create(input[:location])
        Success(result)
      rescue StandardError => e
        Failure("API Error: #{e}")
      end
    end
  end
end
