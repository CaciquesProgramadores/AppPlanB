
# frozen_string_literal: true

require 'roda'

module LastWillFile
  # Web controller for Credence API
  class App < Roda
    route('notes') do |routing|
      routing.on do
        # GET /notes/
=begin
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
=end
          routing.redirect '/auth/login' unless @current_account.logged_in?
          @projects_route = '/notes'

          routing.on(String) do |proj_id|
            @project_route = "#{@projects_route}/#{proj_id}"

            # GET /notes/[proj_id]
            routing.get do
              proj_info = GetNote.new(App.config).call(
                @current_account, proj_id
              )
              project = Note.new(proj_info)

              view :note, locals: {
                current_account: @current_account, note: note
              }
            rescue StandardError => e
              puts "#{e.inspect}\n#{e.backtrace}"
              flash[:error] = 'Note not found'
              routing.redirect @projects_route
            end
# =begin
            # POST /notes/[proj_id]/collaborators
            routing.post('collaborators') do
              action = routing.params['action']
              collaborator_info = Form::CollaboratorEmail.call(routing.params)
              if collaborator_info.failure?
                flash[:error] = Form.validation_errors(collaborator_info)
                routing.halt
              end

              task_list = {
                'add'    => { service: AddCollaborator,
                              message: 'Added new collaborator to project' },
                'remove' => { service: RemoveCollaborator,
                              message: 'Removed collaborator from project' }
              }

              task = task_list[action]
              task[:service].new(App.config).call(
                current_account: @current_account,
                collaborator: collaborator_info,
                project_id:   proj_id
              )
              flash[:notice] = task[:message]

            rescue StandardError
              flash[:error] = 'Could not find collaborator'
            ensure
              routing.redirect @project_route
            end
# =end
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
            puts "FAILURE Creating Project: #{e.inspect}"
            flash[:error] = 'Could not create project'
          ensure
            routing.redirect @projects_route
          end
        end
      end
    end
  end
#end
