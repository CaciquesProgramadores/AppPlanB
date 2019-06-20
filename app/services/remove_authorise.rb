# frozen_string_literal: true

# Service to add authorise to project
class RemoveAuthorise
    class AuthoriseNotRemoved < StandardError; end
  
    def initialize(config)
      @config = config
    end
  
    def api_url
      @config.API_URL
    end
  
    def call(current_account:, project_id:)
      config_url = "#{api_url}/notes"
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .delete(config_url, json: { id: project_id })
  
      raise AuthoriseNotRemoved unless response.code == 200
    end
  end
  