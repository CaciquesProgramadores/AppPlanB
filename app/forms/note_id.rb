# frozen_string_literal: true

require_relative 'form_base'

module LastWillFile
  module Form
    NewNote = Dry::Validation.Params do
      configure do
        config.messages_file = File.join(__dir__, 'errors/new_note.yml')
      end
      required(:id).filled
      required(:title).maybe
      optional(:files_id).maybe
      required(:description).maybe
    end
  end
end