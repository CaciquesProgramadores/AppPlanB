# frozen_string_literal: true

require_relative 'form_base'

module LastWillFile
  module Form
    NewDocument = Dry::Validation.Params do
      configure do
        config.messages_file = File.join(__dir__, 'errors/new_note.yml')
      end

      required(:title).filled(max_size?: 256, format?: FILENAME_REGEX)
      optional(:files_id).maybe(format?: PATH_REGEX)
      required(:description).maybe

      configure do
        config.messages_file = File.join(__dir__, 'errors/new_note.yml')
      end
    end
  end
end