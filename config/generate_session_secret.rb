# frozen_string_literal: true

require 'securerandom'
require 'yaml'

secret = SecureRandom.hex(32)

secrets_file_path = File.expand_path('../config/secrets.yaml', __dir__)

secrets = File.exist?(secrets_file_path) ? YAML.load_file(secrets_file_path) : {}

secrets['development'] ||= {}
secrets['development']['SESSION_SECRET'] ||= secret

secrets['test'] ||= {}
secrets['test']['SESSION_SECRET'] ||= secret

secrets['production'] ||= {}
secrets['production']['SESSION_SECRET'] ||= secret

File.write(secrets_file_path, secrets.to_yaml)
