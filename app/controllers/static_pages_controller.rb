class StaticPagesController < ApplicationController
  configure do
    set :views, 'app/views/static_pages'
  end

  # TODO: Add yard documentation
  get "/" do
    erb :index
  end

  # TODO: Add yard documentation
  get "/static_pages/more_info" do
    erb :more_info
  end

  # TODO: Add yard documentation
  get "/static_pages/contact_us" do
    erb :contact_us
  end
end
