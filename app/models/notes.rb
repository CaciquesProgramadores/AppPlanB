# frozen_string_literal: true

require_relative 'note'

module LastWillFile
  # Behaviors of the currently logged in account
  class Notes
    attr_reader :all

    def initialize(notes_list)
      @all = notes_list.map do |note|
        Note.new(note)
      end
    end
  end
end
