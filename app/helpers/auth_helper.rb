# frozen_string_literal: true

##
# Module for providing HTTP Basic Authentication in Sinatra
# based on User model with phone number and hashed PIN.
#
# == Usage
#   require_relative 'auth_helper'
#   helpers AuthHelper
#
#   before '/protected/*' do
#     protected!
#   end
#
#   get '/protected/dashboard' do
#     "Welcome, #{@current_user.name}"
#   end
#
# == Requirements
# - User model must have:
#   - +phone_number+ as the unique identifier
#   - +authenticate_pin(pin)+ method to verify the PIN using bcrypt
#
module AuthHelper
  ##
  # Enforces basic authentication for a route.
  # If authentication fails, sends a 401 Unauthorized response.
  #
  # @return [void]
  def protected!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  ##
  # Checks HTTP Basic credentials against the User model.
  #
  # On success, sets +@current_user+ for use in routes and views.
  #
  # @return [Boolean] true if credentials are valid
  def authorized?
    @auth ||= Rack::Auth::Basic::Request.new(request.env)

    if @auth.provided? && @auth.basic? && @auth.credentials
      phone_number, pin = @auth.credentials
      user = User.where(phone_number: phone_number).first

      if user && user.authenticate_pin(pin)
        @current_user = user
        return true
      end
    end

    false
  end
end
