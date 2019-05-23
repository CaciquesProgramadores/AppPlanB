
# frozen_string_literal: true

require 'roda'

module LastWillFile
  # Web controller for Credence API
  class App < Roda
    route('notes') do |routing|
      routing.on do
        # GET /notes/
        routing.get do
          if @current_account.logged_in?
            note_list = GetAllNotes.new(App.config).call(@current_account)

            notes = Notes.new(note_list)

            view :notes_all,
                 locals: { current_user: @current_account, notes: notes }
          else
            routing.redirect '/auth/login'
          end
        end
      end
    end
  end
end
