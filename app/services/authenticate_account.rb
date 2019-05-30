# frozen_string_literal: true

require 'http'

module LastWillFile
  # Returns an authenticated user, or nil
  class AuthenticateAccount
    class UnauthorizedError < StandardError; end

    def initialize(config)
      @config = config
      puts 'HUNTing 2!!!: '
    end

    def call(username:, password:)
      response = HTTP.post("#{@config.API_URL}/auth/authenticate",
                           json: { username: username, password: password })
      puts 'HUNT 2!!!: ' + response.code.to_s
      raise(UnauthorizedError) if response.code == 403
      puts 'HUNT 3!!!: ' + response.code.to_s
      raise if response.code != 200

      account_info = response.parse['attributes']

      {
        account: account_info['account'],
        auth_token: account_info['auth_token']
      }
    end
  end
end
