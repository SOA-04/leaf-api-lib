# frozen_string_literal: true

module LeafAPI
  module Entity
    # This is a class to represent the concept of trip on the map.
    # This may include strategies like 'driving', 'bicycling', 'school_bus', 'walking', 'trasit'...etc.
    class Trip
      attr_reader :starting_point, :destination, :strategy

      def initialize(starting_point, destination, strategy, token)
        @starting_point = starting_point
        @destination = destination
        @strategy = strategy
        @token = token
      end

      def duration
        data = Service::GoogleMapsAPI.new(@token).distance_matrix(@starting_point, @destination, @strategy)
        data['rows'][0]['elements'][0]['duration']['value']
      end
    end
  end
end
