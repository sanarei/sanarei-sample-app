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

  ##
  # Renders the edit form for the authenticated user's account details.
  #
  # This route is protected by HTTP Basic Authentication using the `protected!` helper.
  # It loads the current user into +@current_user+ and renders the `:edit_account` view,
  # which typically contains a form to update user information.
  #
  # == Route
  #   GET /users/edit
  #
  # == Authentication
  # - Requires valid HTTP Basic credentials.
  # - Responds with 401 Unauthorized if credentials are invalid.
  #
  # == View Variables
  # - +@current_user+:: The currently authenticated User object, whose details will be edited.
  #
  # == Example curl request (to view the form in browser)
  #   curl -u 0712345678:1234 http://localhost:4000/users/edit
  #
  # @return [String] Rendered HTML for the edit account form
  get '/edit' do
    protected!
    erb :edit
  end

  ##
  # Updates the authenticated user's account details with permitted fields.
  #
  # This route uses HTTP Basic Authentication via the `protected!` helper to ensure
  # only authorized users can access it. It uses strong parameter filtering through
  # `permit_params` to prevent mass assignment vulnerabilities.
  #
  # == Route
  #   PATCH /users/update
  #
  # == Request Method
  #   Must be sent as POST with a hidden `_method=patch` input
  #   since browsers don't support PATCH natively.
  #
  # == Authentication
  # - Requires valid HTTP Basic credentials.
  # - Sets +@current_user+ on success.
  #
  # == Parameters (form-encoded)
  # - +name+ [String] — User’s full name (optional)
  # - +phone_number+ [String] — User’s phone number (optional)
  # - +national_id+ [String] — User’s ID number (optional)
  # - +pin+ [String] — User’s PIN (optional)
  #
  # == Protected Fields
  # - Fields not explicitly permitted (e.g., +_method+) are ignored.
  # - Blank values (empty strings or whitespace) are removed before update.
  #
  # == Behavior
  # - On success: Updates user and redirects to `/my_account`
  # - On failure: Re-renders the edit form view (`:edit_account`)
  #
  # == Example curl request
  #   curl -X POST -u 0712345678:1234 -d "_method=patch&name=Alice" \
  #   http://localhost:4000/users/update
  #
  # @return [String] Redirects or renders edit view based on success
  patch "/update" do
    protected!
    allowed_fields = %w[name phone_number national_id]
    if @current_user.update_attributes(permit_params(*allowed_fields))
      session[:success] = "Your account details have been updated!"
      redirect '/users/my_account'
    else
      erb :edit_account
    end
  end
end
