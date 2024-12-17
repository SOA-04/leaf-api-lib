# frozen_string_literal: true

module Views
  # View for a plan
  class Processing
    def initialize(config, id)
      @id = id
      @config = config
    end

    def ws_channel_id
      @id
    end

    def ws_javascript
      "#{@config.API_URL}/faye/faye.js"
    end

    def ws_route
      "#{@config.API_URL}/faye/faye"
    end
  end
end
