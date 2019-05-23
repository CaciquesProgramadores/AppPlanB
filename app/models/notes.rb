# frozen_string_literal: true

require_relative 'note'

module LastWillFile
  # Behaviors of the currently logged in account
  class Notes
    attr_reader :all

    def initialize(projects_list)
      @all = projects_list.map do |proj|
        Note.new(proj)
      end
    end
  end
end
