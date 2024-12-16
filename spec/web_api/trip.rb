# frozen_string_literal: true

require_relative '../../app/infrastructure/web_api/trips'
require_relative '../../../../config/environment'

# Initialize the API client with your backend's endpoint
API_URL = 'http://localhost:9292'
api_client = Leaf::WebAPI::Trip.new(API_URL) # Replace with the correct API endpoint
puts "API client initialized: #{api_client.inspect}"

# Define test input
origin = '123 Main St, Springfield'
destination = '456 Elm St, Shelbyville'
strategy = 'walking'

begin
  # Call the create_trip method
  response = api_client.create_trip(origin, destination, strategy)

  # Print the response to check the output
  puts "Trip created successfully: #{response.inspect}"
rescue StandardError => e
  # Print the error if something goes wrong
  puts "Error creating trip: #{e.message}"
end
