class UsersController < ApplicationController
  configure do
    set :views, 'app/views/users'
  end

  get "/register" do
    erb :register
  end

  post "/register" do
    user = User.new(params)
    if user.save
      session[:success] = "Registration successful for #{user.name}!"
      redirect '/'
    else
      @errors = user.errors.messages
      logger.error "Error saving user details #{user.errors.messages}. Params: #{params.inspect}"
      erb :register
    end
  end

  get "/login" do
    erb :login
  end

  ##
  # Displays the authenticated user's account details page.
  #
  # This route is protected by HTTP Basic Authentication using the `protected!` helper.
  # The authenticated user is made available as `@current_user`, which can be accessed in the view.
  #
  # == Route
  #   GET /users/my_account
  #
  # == Authentication
  # - Requires valid HTTP Basic credentials.
  # - If authentication fails, responds with 401 Unauthorized.
  # - On success, renders the `:my_account` ERB view.
  #
  # == View Variables
  # - +@current_user+:: The currently authenticated User object
  #
  # == Example curl request
  #   curl -u 0712345678:1234 http://localhost:4000/users/my_account
  #
  # @return [String] Rendered HTML from the `:my_account` view
  get '/my_account' do
    protected!
    erb :my_account
  end
end
