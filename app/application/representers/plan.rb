# frozen_string_literal: true

require 'ostruct'
require 'roar/decorator'
require 'roar/json'
require_relative 'trip'

module Leaf
  module Representer
    # Represents a CreditShare value
    class Plan < Roar::Decorator
      include Roar::JSON

      property :id
      property :strategy
      property :origin, extend: Representer::Location, class: OpenStruct
      property :destination, extend: Representer::Location, class: OpenStruct
      property :duration
      property :distance
      property :leave_at
      property :arrive_at
      collection :trips, extend: Representer::Trip, class: OpenStruct
    end
  end
end
