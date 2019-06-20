
# frozen_string_literal: true

require 'roda'
require 'pry'
module LastWillFile
  # Web controller for LastWillFile API
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
              #binding.pry
              view :note, locals: {
                current_account: @current_account, note: note
              }
              
            rescue StandardError => e
              puts "#{e.inspect}\n#{e.backtrace}"
              flash[:error] = 'Note not found'
              routing.redirect @notes_route
            end

             # POST /notes/[proj_id]/executors
             routing.post('executors') do
              action = routing.params['action']
              executor_info = Form::ExecutorEmail.call(routing.params)
              
              if executor_info.failure?
                flash[:error] = Form.validation_errors(executor_info)
                routing.halt
              end
              
              task_list = {
                'add'    => { service: AddExecutor,
                              message: 'Added new authorisor to note' },
                'remove' => { service: RemoveExecutor,
                              message: 'Removed authorisor from note' }
              }
              
              task = task_list[action]
              task[:service].new(App.config).call(
                current_account: @current_account,
                executor: executor_info,
                project_id:   proj_id
              )
              
              #view :notes_all,
              #locals: { current_user: @current_account, notes: notes }
               #binding.pry 
              flash[:notice] = task[:message]

            rescue StandardError
              flash[:error] = 'Could not find authorisor'
            ensure
              routing.redirect @project_route
            end

            # POST /notes/[proj_id]/inheritors/
            routing.post('inheritors') do
              document_data = Form::NewInheritor.call(routing.params)
              if document_data.failure?
                flash[:error] = Form.message_values(document_data)
                routing.halt
              end

              CreateNewInheritor.new(App.config).call(
                current_account: @current_account,
                note_id: proj_id,
                inheritor_data: document_data.to_h
              )

              flash[:notice] = 'Your inheritor was added'
            rescue StandardError => error
              #binding.pry
              puts error.inspect
              puts error.backtrace
              flash[:error] = 'Could not add inheritor'
            ensure
              routing.redirect @project_route
            end

            # POST /notes/[proj_id]/edit
            routing.post('edit') do
              routing.redirect '/auth/login' unless @current_account.logged_in?
              puts "NOTE: #{routing.params}"
              project_data = routing.params
              
              UpdateNote.new(App.config).call(
                current_account: @current_account,
                project_data: project_data.to_h
              )

              flash[:notice] = 'note updated'
            rescue StandardError => e
              puts "FAILURE to Update Note: #{e.inspect}"
              flash[:error] = 'Could not Update Note'
            ensure
              routing.redirect @notes_route
            end
            
            # POST /notes/[note_id]/delete
            routing.post('delete') do
              routing.redirect '/auth/login' unless @current_account.logged_in?
              puts "NOTE: #{routing.params}"
              
              project_data = routing.params
              
              DeleteNote.new(App.config).call(
                current_account: @current_account,
                project_data: project_data
              )

              flash[:notice] = 'Note deleted'
            rescue StandardError => e
              #binding.pry
              puts "FAILURE Creating Note: #{e.inspect}"
              #flash[:error] = 'Could not Delete Note'
            ensure
              routing.redirect @notes_route
            end
          end

          # GET /notes/
          routing.get do
            note_list = GetAllNotes.new(App.config).call(@current_account)

            notes = Notes.new(note_list)

            view :notes_all, locals: {
              current_account: @current_account, notes: notes
            }
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
