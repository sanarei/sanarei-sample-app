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
end
