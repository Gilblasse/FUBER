require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  before do
    # We set this @title instance variable to a default value, so that if any of our pages *don't* want a custom title, something will appear in the <title> tag.
    @stylesheet_link = "/stylesheets/main.css"
  end

  get "/" do
    @stylesheet_link = "/stylesheets/main.css"
    erb :welcome
  end


end
