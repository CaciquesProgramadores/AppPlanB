# frozen_string_literal: true

require_relative 'form_base'

module LastWillFile
  module Form
    NewNote = Dry::Validation.Params do
      required(:title).filled
      optional(:description).maybe(format?: URI::DEFAULT_PARSER.make_regexp)
=begin
      required(:title).filled(max_size?: 256, format?: FILENAME_REGEX)
      optional(:files_id).maybe(format?: PATH_REGEX)
      required(:description).maybe
=end
      configure do
        config.messages_file = File.join(__dir__, 'errors/new_note.yml')
      end
    end
  end
end