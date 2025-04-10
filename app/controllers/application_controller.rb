require './config/environment'
require_relative '../helpers/link_helper'

class ApplicationController < Sinatra::Base
  set :host_authorization, { permitted_hosts: ENV['PROD_DOMAIN'] }
  helpers LinkHelper

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    erb :index
  end

  get "/more_info" do
    erb :more_info
  end

  get "/contact_us" do
    erb :contact_us
  end
end
