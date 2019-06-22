# frozen_string_literal: true

require 'http'
require 'pry'
require 'json'
require 'pry'

module LastWillFile
  # Returns an authenticated user, or nil
  class InviteInheritor
    class InviteInheritorError < StandardError; end

    def initialize(config)
      @config = config
    end

    def call(current_account:, req_data:)
      invitation_token = SecureMessage.encrypt(req_data)
      #binding.pry
      req_data['verification_url'] = \
        "#{@config.APP_URL}/auth/register/#{invitation_token}"
      
      id = req_data['note_id'].to_i
      #binding.pry
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .post("#{@config.API_URL}/notes/#{id}/invitation", json: req_data)
      #response = HTTP.post("#{@config.API_URL}/notes/#{id}/invitation",
                           #json: req_data)
      raise(InviteInheritorError) unless response.code == 202

      response.parse
    end
  end
end
