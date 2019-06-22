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
      response = HTTP
        .auth("Bearer #{current_account.auth_token}")
        .delete("#{api_url}/notes/#{project_id}/executors",
                json: { email: collaborator[:email] })
  
      raise ExecutorNotRemoved unless response.code == 200
    end
  end
  