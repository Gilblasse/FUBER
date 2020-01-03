class DriversController < ApplicationController

  # GET: /drivers
  get "/driver/dashboard" do
    @driver = authenticate_user

    erb :"/drivers/dashboard.html"
  end

  # GET: /drivers/new
  get "/drivers/new" do
    erb :"/drivers/new.html"
  end

  # POST: /drivers
  post "/drivers" do
    redirect "/drivers"
  end

  # GET: /drivers/5
  get "/drivers/:id" do
    erb :"/drivers/show.html"
  end

  # GET: /drivers/5/edit
  get "/drivers/:id/edit" do
    erb :"/drivers/edit.html"
  end

  # PATCH: /drivers/5
  patch "/drivers/:id" do
    redirect "/drivers/:id"
  end

  # DELETE: /drivers/5/delete
  delete "/drivers/:id/delete" do
    redirect "/drivers"
  end


  helpers do 

    def authenticate_user
      redirect "/login" if !Helpers.logged_in?(session)
      redirect "/not-found" if Helpers.current_user(session).class.to_s != "Driver"
      Helpers.current_user(session)
    end
  
  end




end
