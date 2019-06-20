# frozen_string_literal: true
require 'pry'
# Service to add collaborator to project
class AddExecutor
    class ExecutorNotAdded < StandardError; end
  
    def initialize(config)
      @config = config
    end
  
    def api_url
      @config.API_URL
    end
  
    def call(current_account:, executor:, project_id:)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .put("#{api_url}/notes/#{project_id}/executors",
                          json: { email: executor[:email] })
      binding.pry
      raise ExecutorNotAdded unless response.code == 200
    end
  end