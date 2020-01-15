require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
  end

  404 Error!
  not_found do
    status 404
    erb :not_found
  end

  before do
    # We set this @title instance variable to a default value, so that if any of our pages *don't* want a custom title, something will appear in the <title> tag.
    @stylesheet_link = "/stylesheets/main.css"
  end

  get "/" do
    @stylesheet_link = "/stylesheets/main.css"
    erb :welcome
  end

  get "/not-found" do
    @stylesheet_link = "/stylesheets/main.css"
    erb :not_found 
  end
 

end
