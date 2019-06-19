# frozen_string_literal: true

require 'http'
require 'pry'

# Create a new configuration file for a project
class CreateNewInheritor
  def initialize(config)
    @config = config
  end

  def api_url
    @config.API_URL
  end

  def call(current_account:, note_id:, inheritor_data:)
    config_url = "#{api_url}/notes/#{note_id}/inheritors"
    response = HTTP.auth("Bearer #{current_account.auth_token}")
                   .post(config_url, json: inheritor_data)
    #binding.pry

    response.code == 201 ? response.parse : raise
    
  end
end
