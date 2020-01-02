class PassengersController < ApplicationController

  
  get "/passenger/trip/new" do
    @stylesheet_link = "/stylesheets/passengers/dashboard.css"
    @passenger = authenticate_user  
    
    erb :"/passengers/book-trip.html"
  end

  post "/passengers/trip" do
    binding.pry
    redirect "/passengers/trip/drivers/new"
  end

  get "/passengers/trip/drivers/new" do
    erb :"/passengers/book-driver.html"
  end

  post "/passengers/trip/drivers" do
    redirect "/passengers/trip/drivers/new"
  end

  get " " do 

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
