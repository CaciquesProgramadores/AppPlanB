# frozen_string_literal: true

require 'http'

module LastWillFile
  # Returns all notes belonging to an account
  class GetExistences
    # Error for cannot find existences
    class NotFoundError < StandardError
      def message
        'We could not find that existences'
      end
    end

    def initialize(config)
      @config = config
    end

    def call(current_account)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                   .get("#{@config.API_URL}/existences")

      existences = response.parse['data']
      puts existences
      puts existences.kind_of?(Array)
      puts existences[0]
      puts existences[0]['title']

      existences[0]
    end
  end
end
