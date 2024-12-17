# frozen_string_literal: true

require 'securerandom'
require_relative '../../../../config/environment'
require_relative '../../../presentation/view_objects/query'
require_relative '../../../presentation/view_objects/processing'
require_relative '../../forms/new_query'
require_relative '../../services/queries/add_query'
require_relative '../../services/queries/get_query'

module Leaf
  # Application
  class App < Roda
    plugin :multi_route
    plugin :flash

    route('queries') do |routing| # rubocop:disable Metrics/BlockLength
      routing.post 'submit' do
        query_request = Forms::NewQuery.new.call(routing.params)
        query_result = Service::AddQuery.new.call(query_request)

        if query_result.failure?
          puts(query_result.failure)
          flash[:error] = query_result.failure
          routing.redirect '/queries'
        end

        query_id = query_result.value!
        routing.session[:visited_queries] ||= []
        routing.session[:visited_queries].insert(0, query_id[:id]).uniq!
        flash[:notice] = 'Query created successfully.'
        routing.redirect query_id[:id]
      end

      routing.is do
        routing.get do
          routing.scope.view 'query/query_form'
        end
      end

      routing.on String do |query_id| # rubocop:disable Metrics/BlockLength
        routing.on Integer do |plan_id|
          query = Service::GetQuery.new.call(query_id).value!

          unless plan_id.between?(0, query.plans.length - 1)
            flash[:error] = 'Index out of range.'
            routing.redirect "/queries/#{query_id}"
          end

          routing.scope.view 'plans/plan_result', locals: { plan: query.plans[plan_id], query_id: query_id }
        rescue StandardError => e
          flash[:error] = e
        end

        routing.is do
          routing.get do
            query = Service::GetQuery.new.call(query_id)

            if query.failure?
              flash[:notice] = nil
              processing_view = Views::Processing.new(App.config, query_id)
              return routing.scope.view('query/query_wait', locals: { processing: processing_view })
            end

            routing.scope.view('query/query_result', locals: { query: query.value! })
          end

          routing.delete do
            routing.session[:visited_queries].delete(query_id)
            flash[:notice] = "Query '#{query_id}' has been removed from history."
            routing.redirect '/queries'
          end
        end
      end
    end
  end
end
