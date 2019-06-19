# frozen_string_literal: true
require 'pry'
# Service to add collaborator to project
class AddAuthorise
    class AuthoriseNotAdded < StandardError; end
  
    def initialize(config)
      @config = config
    end
  
    def api_url
      @config.API_URL
    end
  
    def call(current_account:, authorise:, project_id:)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .put("#{api_url}/notes/#{project_id}/authorises",
                          json: { email: authorise[:email] })
      #binding.pry
      raise AuthoriseNotAdded unless response.code == 200
    end
  end