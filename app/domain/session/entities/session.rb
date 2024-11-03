# frozen_string_literal: true

module Leaf
  # This is a class to represent the concept of Session on the web.
  class Session
    attr_reader :origin, :destination, :strategy

    def initialize(origin: nil, destination: nil, strategy: nil)
      @origin = origin
      @destination = destination
      @strategy = strategy
    end

    def user_origin
      @origin
    end

    def user_destination
      @destination
    end

    def user_strategy
      @strategy
    end

    def set_trip(origin, destination, strategy)
      @origin = origin
      @destination = destination
      @strategy = strategy
    end

    def route_info
      if complete_trip?
        "Route from #{@origin} to #{@destination} by #{@strategy} retrieved!"
      else
        'Please set an origin, destination and strategy first.'
      end
    end

    def complete_trip?
      @origin && @destination && @strategy
    end

    def clear
      @origin = nil
      @destination = nil
      @strategy = nil
    end

    def to_s
      "Origin: #{@origin}, Destination: #{@destination}, strategy: #{@strategy}"
    end
  end
end
