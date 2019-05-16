# frozen_string_literal: true

require 'roda'
require_relative './app'

module LastWillFile
  # Web controller for Credence API
  class App < Roda
    route('auth') do |routing|
      @login_route = '/auth/login'
      routing.is 'login' do
        # GET /auth/login
        routing.get do
          view :login
        end

       # POST /auth/login
       routing.post do
        account = AuthenticateAccount.new(App.config).call(
          username: routing.params['username'],
          password: routing.params['password']
        )

        SecureSession.new(session).set(:current_account, account)
        flash[:notice] = "Welcome back #{account['username']}!"
        routing.redirect '/'
      rescue AuthenticateAccount::UnauthorizedError
        flash[:error] = 'Username and password did not match our records'
        response.status = 403
        routing.redirect @login_route
      rescue StandardError => e
        puts "LOGIN ERROR: #{e.inspect}\n#{e.backtrace}"
        flash[:error] = 'Our servers are not responding -- please try later'
        response.status = 500
        routing.redirect @login_route
      end
    end

    @logout_route = '/auth/logout'
    routing.is 'logout' do
      routing.get do
        session[:current_account] = nil
        routing.redirect @login_route
      end
    end
    end
  end
end
