# frozen_string_literal: true

require 'roda'
require_relative './app'
require 'pry'

module LastWillFile
  # Web controller for LastWillFile API
  class App < Roda
    route('existences') do |routing|
      routing.redirect '/auth/login' unless @current_account.logged_in?

      # GET /existences/
      routing.get do
        existences = GetExistences.new(App.config).call(
          @current_account
        )

        puts existences[0]['title']
        existences.each do |row|
          puts row['email']
          puts 'hello'
          puts row
        end

        view :existences, locals: { existences: existences  }
      rescue GetExistences::NotFoundError => e
        flash[:error] = e.message
        routing.redirect '/'
      end
    end
  end
end
