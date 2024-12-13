# frozen_string_literal: true

require_relative '../../../infrastructure/google_maps/mappers/location_mapper'
require_relative '../../../infrastructure/google_maps/gateways/google_maps_api'
require_relative '../../forms/new_location'
require_relative '../../services/add_location'
require_relative '../../../presentation/view_objects/location'

module Leaf
  # Application
  class App < Roda
    plugin :multi_route

    route('locations') do |routing| # rubocop:disable Metrics/BlockLength
      routing.post 'search' do
        # Validate input using Form Object
        form = Forms::NewLocation.new.call(routing.params)

        if form.failure?
          routing.flash[:error] = form.errors.to_h.values.join(', ')
          routing.redirect '/locations'
        end

        # Encode location query and call service
        location_query = CGI.escape(form[:location].downcase)
        result = Service::AddLocation.new.call(location_query: location_query)

        if result.failure?
          routing.flash[:error] = result.failure
          routing.redirect '/locations'
        end

        # Handle successful result
        location_entity = result.value!
        routing.session[:visited_locations] ||= []
        routing.session[:visited_locations].insert(0, location_entity.name).uniq!
        routing.redirect "/locations/#{location_query}"
      end

      routing.is do
        routing.get do
          routing.scope.view('location/location_form')
        end
      end

      routing.on String do |location_query|
        routing.get do
          location_query = CGI.unescape(location_query)
          location_entity = Leaf::GoogleMaps::LocationMapper.new(
            Leaf::GoogleMaps::API,
            Leaf::App.config.GOOGLE_TOKEN
          ).find(location_query)

          location_view = Views::Location.new(location_entity)
          routing.scope.view('location/location_result', locals: { location: location_view })
        end

        routing.delete do
          routing.session[:visited_locations].delete(location_query)
          routing.flash[:notice] = "Location '#{location_query}' has been removed from history."
          routing.redirect '/locations'
        end
      end
    end
  end
end
