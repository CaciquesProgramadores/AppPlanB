# frozen_string_literal: true

require 'http'

# Returns all notes belonging to an account
class GetInheritor
  def initialize(config)
    @config = config
  end

  def call(user, doc_id)
    response = HTTP.auth("Bearer #{user.auth_token}")
                   .get("#{@config.API_URL}/inheritors/#{doc_id}")
    response.code == 200 ? response.parse['data'] : nil
  end
end
