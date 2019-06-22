# frozen_string_literal: true

require 'roda'
require_relative './app'
require 'pry'

module LastWillFile
  # Web controller for LastWillFile API
  class App < Roda
    route('inheritors') do |routing|
      routing.redirect '/auth/login' unless @current_account.logged_in?

      # GET /inheritors/[doc_id]
      routing.get(String) do |doc_id|
        doc_info = GetInheritor.new(App.config)
                              .call(@current_account, doc_id)
        inheritor = Inheritor.new(doc_info)
        
        view :inheritor, locals: {
          current_account: @current_account, inheritor: inheritor
        }
      end
    end
  end
end