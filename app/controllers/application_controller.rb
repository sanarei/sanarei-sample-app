require './config/environment'
require_relative '../helpers/link_helper'

class ApplicationController < Sinatra::Base
  set :host_authorization, { permitted_hosts: ENV['PROD_DOMAIN'] }
  helpers LinkHelper

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :logging
    file = File.new("log/#{environment}.log", 'a+')
    file.sync = true
    use Rack::CommonLogger, file
    set :logger, Logger.new(file)
  end

  before do
    logger.info "Processing request: #{request.request_method} #{request.path}"
  end
end
