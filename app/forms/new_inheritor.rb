# frozen_string_literal: true

require_relative 'form_base'

module LastWillFile
  module Form
    NewInheritor = Dry::Validation.Params do
      configure do
        config.messages_file = File.join(__dir__, 'errors/new_inheritor.yml')
      end

      required(:fullname).filled(max_size?: 256, format?: FILENAME_REGEX)
      required(:relationship).maybe(format?: PATH_REGEX)
      required(:description).maybe
      required(:phones).maybe
      required(:nickname).maybe
      required(:pgp).maybe
      required(:email).filled
    end
  end
end