class UsersController < ApplicationController
  configure do
    set :views, 'app/views/users'
  end

  get "/register" do
    erb :register
  end

  get "/login" do
    erb :login
  end
end
