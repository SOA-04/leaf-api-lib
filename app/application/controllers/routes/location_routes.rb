# frozen_string_literal: true

require 'securerandom'
require_relative '../../../../config/environment'
require_relative '../../../presentation/view_objects/location'
require_relative '../../forms/new_location'
require_relative '../../services/locations/add_location'
require_relative '../../services/locations/get_location'

module Leaf
  # Application
  class App < Roda
    plugin :multi_route
    plugin :flash

    route('locations') do |routing| # rubocop:disable Metrics/BlockLength
      routing.post 'search' do
        location_request = Forms::NewLocation.new.call(routing.params)
        location_result = Service::AddLocation.new.call(location_request)

        if location_result.failure?
          puts(location_result.failure)
          flash[:error] = location_result.failure
          routing.redirect '/locations'
        end

        # 使用 Plus Code 作為唯一標識符
        plus_code = location_result.value!['plus_code']
        routing.session[:visited_locations] ||= []
        routing.session[:visited_locations].insert(0, plus_code).uniq!
        flash[:notice] = "Location with Plus Code #{plus_code} created or retrieved successfully."
        routing.redirect "/locations/#{CGI.escape(plus_code)}"
      end

      routing.is do
        routing.get do
          routing.scope.view 'location/location_form'
        end
      end

      routing.on String do |plus_code|
        routing.get do
          # puts "#{plus_code}"
          location_result = Service::GetLocation.new.call(CGI.unescape(plus_code))
          # binding.irb
          if location_result.failure?
            puts(location_result.failure)
            flash[:error] = location_result.failure
            routing.redirect '/locations'
          end

          location_view = Views::Location.new(location_result.value!)
          routing.scope.view('location/location_result', locals: { location: location_view })
        end

        routing.delete do
          routing.session[:visited_locations].delete(plus_code)
          flash[:notice] = "Location with Plus Code #{plus_code} has been removed from history."
          routing.redirect '/locations'
        end
      end
    end
  end
end
