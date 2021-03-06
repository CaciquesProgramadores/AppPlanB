# frozen_string_literal: true

require 'roda'
require_relative './app'

module LastWillFile
  # Web controller for LastWillFile API
  class App < Roda
    route('account') do |routing|
      routing.on do
        # GET /account/[username]
        routing.get String do |username|
          account = GetAccountDetails.new(App.config).call(
            @current_account, username
          )

          view :account, locals: { account: account }
        rescue GetAccountDetails::InvalidAccount => e
          flash[:error] = e.message
          routing.redirect '/auth/login'
        end

        # POST /account/<token>
        routing.post String do |registration_token|
          raise 'Passwords do not match or empty' if
            routing.params['password'].empty? ||
            routing.params['password'] != routing.params['password_confirm']

          new_account = SecureMessage.decrypt(registration_token)

          # this is for invited users
          if new_account['username'].nil?
            new_account['username'] = routing.params['username']
            new_account['email'] = routing.params['inh_email']
          end

          CreateAccount.new(App.config).call(
            email: new_account['email'],
            username: new_account['username'],
            password: routing.params['password']
          )


          flash[:notice] = 'Account created! Please login'
          routing.redirect '/auth/login'
        rescue CreateAccount::InvalidAccount => e
          flash[:error] = e.message
          routing.redirect '/auth/register'
        rescue StandardError => e
          flash[:error] = e.message
          routing.redirect(
            "#{App.config.APP_URL}/auth/register/#{registration_token}"
          )
        end
      end
    end
  end
end
