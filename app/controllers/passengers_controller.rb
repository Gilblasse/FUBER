class PassengersController < ApplicationController

  
  get "/passenger/book-trip/new" do
    @stylesheet_link = "/stylesheets/passengers/dashboard.css"
    @passenger = authenticate_user  
    
    erb :"/passengers/book-trip.html"
  end

  post "/passenger/book-trip" do
    passenger = authenticate_user 
    trip = passenger.trips.create(params[:address])

    redirect "/passenger/book-trip/#{trip.id}/driver/new"
  end

  get "/passenger/book-trip/:id/driver/new" do
    @passenger = authenticate_user 
    @trip = Trip.find(params[:id])
    @drivers = Driver.closest_drivers(@trip.from)

    erb :"/passengers/book-driver.html"
  end

  post "/passenger/trip/drivers" do
    redirect "/passenger/trip/drivers/new"
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
