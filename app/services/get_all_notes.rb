
# frozen_string_literal: true

require 'http'

module LastWillFile
  # Returns all notes belonging to an account
  class GetAllNotes
    def initialize(config)
    @config = config
    end

    def call(current_account)
    response = HTTP.auth("Bearer #{current_account.auth_token}")
                   .get("#{@config.API_URL}/notes")

    response.code == 200 ? response.parse['data'] : nil
    end
  end
end
