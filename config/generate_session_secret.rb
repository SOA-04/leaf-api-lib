# frozen_string_literal: true

require 'securerandom'
require 'yaml'

# Generate a secure random 128-character secret
secret = SecureRandom.hex(64)

# Define the file path for `secrets.yml`
secrets_file_path = File.expand_path('../config/secrets.yaml', __dir__)

# Load existing secrets.yml if it exists, or initialize an empty hash
secrets = File.exist?(secrets_file_path) ? YAML.load_file(secrets_file_path) : {}

# Add the generated secret to development and test environments if not already present
secrets['development'] ||= {}
secrets['development']['SESSION_SECRET'] ||= secret

secrets['test'] ||= {}
secrets['test']['SESSION_SECRET'] ||= secret

# Optionally, set it for production if no environment variable is set
secrets['production'] ||= {}
secrets['production']['SESSION_SECRET'] ||= secret

# Write the updated secrets back to `secrets.yml`
File.write(secrets_file_path, secrets.to_yaml)
