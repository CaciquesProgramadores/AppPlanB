# frozen_string_literal: true

# Service to add executor to project
class RemoveExecutor
    class ExecutorNotRemoved < StandardError; end
  
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
  
      raise ExecutorNotRemoved unless response.code == 200
    end
  end
  