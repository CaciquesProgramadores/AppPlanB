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
  
    def call(current_account:, authorise:, project_id:)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .delete("#{api_url}/notes/#{project_id}/authorises",
                             json: { email: authorise[:email] })
  
      raise AuthoriseNotRemoved unless response.code == 200
    end
  end
  