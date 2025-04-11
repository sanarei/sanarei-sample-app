class StaticPagesController < ApplicationController
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
