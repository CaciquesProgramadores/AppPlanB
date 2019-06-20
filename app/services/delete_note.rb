# frozen_string_literal: true
require 'pry'
# Service to add collaborator to project
class DeleteNote
    class NoteNotDeleted < StandardError; end
  
    def initialize(config)
      @config = config
    end
  
    def api_url
      @config.API_URL
    end
  
    def call(current_account:, project_data:)
        config_url = "#{api_url}/notes"

        response = HTTP.auth("Bearer #{current_account.auth_token}")
                        .delete(config_url, json: { id: (project_data['id']).to_i })

      raise NoteNotDeleted unless response.code == 200
    end
  end