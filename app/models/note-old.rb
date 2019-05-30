# frozen_string_literal: true

require_relative 'note'

module LastWillFile
  # Behaviors of the currently logged in account
  class Note
    attr_reader :id, :title, :description, :files_ids, #basic info
                :owner, :inheritors # full details

    def initialize(proj_info)
       @id = proj_info['attributes']['id']
       @title = proj_info['attributes']['title']
       @description = proj_info['attributes']['description']
    end
  end
end