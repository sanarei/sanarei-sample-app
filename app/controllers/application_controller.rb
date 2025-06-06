require './config/environment'
require_relative '../helpers/link_helper'
require_relative '../helpers/auth_helper'
require_relative '../helpers/form_helper'

class ApplicationController < Sinatra::Base
  set :host_authorization, { permitted_hosts: ENV['PROD_DOMAIN'] }
  helpers LinkHelper
  helpers AuthHelper
  helpers FormHelper

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :logging
    file = File.new("log/#{environment}.log", 'a+')
    file.sync = true
    use Rack::CommonLogger, file
    set :logger, Logger.new(file)
    enable :sessions
    enable :method_override
  end

  before do
    @success = session.delete(:success)  # Grab the flash message, then clear it
    logger.info "Processing request: #{request.request_method} #{request.path}"
  end
end
