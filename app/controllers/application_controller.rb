require './config/environment'
require_relative '../helpers/link_helper'
require_relative '../helpers/auth_helper'
require_relative '../helpers/form_helper'

class ApplicationController < Sinatra::Base
  PUBLIC_CACHE_SECONDS = 120 * 60

  set :host_authorization, { permitted_hosts: ENV['PROD_DOMAIN'] }
  helpers LinkHelper
  helpers AuthHelper
  helpers FormHelper

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    set :static_cache_control, [:public, { max_age: PUBLIC_CACHE_SECONDS }]
    enable :logging
    file = File.new("log/#{environment}.log", 'a+')
    file.sync = true
    use Rack::CommonLogger, file
    set :logger, Logger.new(file)
    enable :sessions
    enable :method_override
  end

  before do
    # Do not open a session for anonymous page requests. Rack would otherwise
    # add Set-Cookie, which prevents the middleware from caching public pages.
    @success = session.delete(:success) if session_request?
    logger.info "Processing request: #{request.request_method} #{request.path}"
  end

  private

  def session_request?
    request.env['HTTP_COOKIE'].to_s.include?('rack.session=')
  end
end
