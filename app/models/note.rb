# frozen_string_literal: true

require_relative 'note'

module LastWillFile
  # Behaviors of the currently logged in account
  class Note
    attr_reader :id, :name, :repo_url

     def initialize(proj_info)
      @id = proj_info['attributes']['id']
      @name = proj_info['attributes']['name']
      @repo_url = proj_info['attributes']['repo_url']
     end
  end
end