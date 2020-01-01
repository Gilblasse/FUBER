class PassengersController < ApplicationController

  # GET: /passengers
  get "/passenger/dashboard" do
    @passenger = authenticate_user  
     
    erb :"/passengers/dashboard.html"
  end

  # GET: /passengers/new
  get "/passengers/new" do
    erb :"/passengers/new.html"
  end

  # POST: /passengers
  post "/passengers" do
    redirect "/passengers"
  end

  # GET: /passengers/5
  get "/passengers/:id" do
    erb :"/passengers/show.html"
  end

  # GET: /passengers/5/edit
  get "/passengers/:id/edit" do
    erb :"/passengers/edit.html"
  end

  # PATCH: /passengers/5
  patch "/passengers/:id" do
    redirect "/passengers/:id"
  end

  # DELETE: /passengers/5/delete
  delete "/passengers/:id/delete" do
    redirect "/passengers"
  end


  helpers do 

    def authenticate_user
      redirect "/login" if !Helpers.logged_in?(session)
      redirect "/not-found" if Helpers.current_user(session).class.to_s != "Passenger"
      Helpers.current_user(session)
    end
  
  end





end
