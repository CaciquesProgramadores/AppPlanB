
# frozen_string_literal: true

require 'roda'

module LastWillFile
  # Web controller for Credence API
  class App < Roda
    route('notes') do |routing|
      routing.on do
        # GET /notes/
          routing.redirect '/auth/login' unless @current_account.logged_in?
          @notes_route = '/notes'

          routing.on(String) do |proj_id|
            @project_route = "#{@notes_route}/#{proj_id}"

            # GET /notes/[proj_id]
            routing.get do
              proj_info = GetNote.new(App.config).call(
                @current_account, proj_id
              )
              note = Note.new(proj_info)

              view :note, locals: {
                current_account: @current_account, note: note
              }
            rescue StandardError => e
              puts "#{e.inspect}\n#{e.backtrace}"
              flash[:error] = 'Note not found'
              routing.redirect @notes_route
            end

             # POST /notes/[proj_id]/authorises
             routing.post('authorises') do
              action = routing.params['action']
              authorise_info = Form::AuthoriseEmail.call(routing.params)
              if authorise_info.failure?
                flash[:error] = Form.validation_errors(authorise_info)
                routing.halt
              end

              task_list = {
                'add'    => { service: AddAuthorise,
                              message: 'Added new authorisor to project' },
                'remove' => { service: RemoveAuthorise,
                              message: 'Removed authorisor from project' }
              }

              task = task_list[action]
              task[:service].new(App.config).call(
                current_account: @current_account,
                authorise: authorise_info,
                note_id:   proj_id
              )
              flash[:notice] = task[:message]

            rescue StandardError
              flash[:error] = 'Could not find authorisor'
            ensure
              routing.redirect @project_route
            end

            # POST /notes/[proj_id]/inheritor/
            routing.post('notes') do
              document_data = Form::NewInheritor.call(routing.params)
              if document_data.failure?
                flash[:error] = Form.message_values(document_data)
                routing.halt
              end

              CreateNewInheritor.new(App.config).call(
                current_account: @current_account,
                note_id: note_id,
                document_data: document_data.to_h
              )

              flash[:notice] = 'Your inheritor was added'
            rescue StandardError => error
              puts error.inspect
              puts error.backtrace
              flash[:error] = 'Could not add inheritor'
            ensure
              routing.redirect @project_route
            end
          end

          # GET /notes/
          routing.get do
            note_list = GetAllNotes.new(App.config).call(@current_account)

            notes = Notes.new(note_list)

            view :notes_all,
                 locals: { current_user: @current_account, notes: notes }
          end

          # POST /notes/
          routing.post do
            routing.redirect '/auth/login' unless @current_account.logged_in?
            puts "NOTE: #{routing.params}"
            project_data = Form::NewNote.call(routing.params)
            if project_data.failure?
              flash[:error] = Form.message_values(project_data)
              routing.halt
            end

            CreateNewNote.new(App.config).call(
              current_account: @current_account,
              project_data: project_data.to_h
            )

            flash[:notice] = 'Add inheritor and executor to your new will note'
          rescue StandardError => e
            puts "FAILURE Creating Note: #{e.inspect}"
            flash[:error] = 'Could not create Note'
          ensure
            routing.redirect @notes_route
          end
        end
      end
    end
  end
#end
