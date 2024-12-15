# frozen_string_literal: true

module Views
  # View for a single query entity
  class Trip
    def initialize(trip)
      @trip = trip
    end

    def origin_name
      @trip.origin.name
    end

    def destination_name
      @trip.destination.name
    end

    def strategy
      @trip.strategy
    end

    def distance
      @trip.distance
    end

    def duration
      @trip.duration / 60
    end
  end
end
