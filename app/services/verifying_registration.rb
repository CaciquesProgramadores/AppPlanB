# frozen_string_literal: true

require 'http'
require 'pry'
require 'json'

module LastWillFile
  # Returns an authenticated user, or nil
  class VerifyRegistration
    class VerificationError < StandardError; end

    def initialize(config)
      @config = config
    end

    def call(registration_data)
      registration_token = SecureMessage.encrypt(registration_data)
      #binding.pry
      registration_data['verification_url'] = \
        "#{@config.APP_URL}/auth/register/#{registration_token}"

      response = HTTP.post(
        "#{@config.API_URL}/auth/register",
        json: SignedMessage.sign(registration_data)
      )
      #binding.pry
      raise(VerificationError) unless response.code == 202
      #binding.pry
      response.parse
    end
  end
end
