# frozen_string_literal: true

require 'http'
require 'pry'

# Create a new configuration file for a project
class CreateNewNote
  def initialize(config)
    @config = config
  end

  def api_url
    @config.API_URL
  end

  def call(current_account:, project_data:)
    config_url = "#{api_url}/notes"

    response = HTTP.auth("Bearer #{current_account.auth_token}")
                   .post(config_url, json: project_data)

    response.code == 201 ? response.parse : raise
  end
end
