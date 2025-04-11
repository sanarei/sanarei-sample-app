require './config/environment'
require_relative '../helpers/link_helper'

class ApplicationController < Sinatra::Base
  set :host_authorization, { permitted_hosts: ENV['PROD_DOMAIN'] }
  helpers LinkHelper

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end
end
