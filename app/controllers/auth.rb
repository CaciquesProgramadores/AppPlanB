# frozen_string_literal: true

require 'roda'
require_relative './app'

module LastWillFile
 # Web controller for Credence API
 class App < Roda
  route('auth') do |routing| # rubocop:disable Metrics/BlockLength
    @login_route = '/auth/login'
    routing.is 'login' do
      # GET /auth/login
      routing.get do
        view :login
      end

      # POST /auth/login
      routing.post do
        credentials = Form::LoginCredentials.call(routing.params)

        if credentials.failure?
          flash[:error] = 'Please enter both username and password'
          routing.redirect @login_route
        end
        puts "hunt 1"
        authenticated = AuthenticateAccount.new(App.config).call(credentials)
        puts "hunt 2"
          current_account = Account.new(
            authenticated[:account],
            authenticated[:auth_token]

        )

        CurrentSession.new(session).current_account = current_account

        flash[:notice] = "Welcome back #{current_account.username}!"
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

    # GET /auth/logout
    @logout_route = '/auth/logout'
    routing.is 'logout' do
      routing.get do
        CurrentSession.new(session).delete
        routing.redirect @login_route
      end
    end

    @register_route = '/auth/register'
    routing.on 'register' do
      routing.is do
        # GET /auth/register
        routing.get do
          view :register
        end

        # POST /auth/register
        routing.post do
          registration = Form::Registration.call(routing.params)

          if registration.failure?
            flash[:error] = Form.validation_errors(registration)
            routing.redirect @register_route
          end

          VerifyRegistration.new(App.config).call(registration)
          flash[:notice] = 'Please check your email for a verification link'
          routing.redirect '/'
        rescue StandardError => e
          puts "ERROR VERIFYING REGISTRATION: #{routing.params}\n#{e.inspect}"
          flash[:error] = 'Please use English characters for username only'
          routing.redirect @register_route
        end
      end

      # GET /auth/register/<token>
      routing.get(String) do |registration_token|

        # if RegistrationToken.expiredToken?(registration_token)
        #   flash[:error] = 'Registration details are not valid'
        #   routing.redirect @register_route
        # else
          flash.now[:notice] = 'Email Verified! Please choose a new password'

          new_account = SecureMessage.decrypt(registration_token)
          # new_account = RegistrationToken.payload(registration_token)
          view :register_confirm,
               locals: { new_account: new_account,
                         registration_token: registration_token }
        # end






      end
    end
  end
 end
end
