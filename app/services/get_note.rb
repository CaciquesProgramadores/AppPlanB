# frozen_string_literal: true

require 'http'

# Returns all notes belonging to an account
class GetNote
  def initialize(config)
    @config = config
  end

  def call(current_account, note_id)
    response = HTTP.auth("Bearer #{current_account.auth_token}")
                   .get("#{@config.API_URL}/notes/#{note_id}")

    response.code == 200 ? response.parse : nil
  end
end