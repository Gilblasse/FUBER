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




  get '/passenger/book-trip/:id/edit' do 
    @passenger = authenticate_user
    @trip = Trip.find(params[:id])

    erb :"/passengers/book-trip-edit.html"
  end

  patch '/passenger/book-trip/:id' do 
    
    redirect "/passenger/book-trip/#{params[:id]}/driver/new"
  end




  get "/passenger/book-trip/:id/driver/new" do
    @stylesheet_link = "/stylesheets/passengers/dashboard.css"
    @passenger = authenticate_user 
    @trip = Trip.find(params[:id])
    @drivers = Driver.closest_drivers(@trip.from)
    @trip_leg = GMAPS.directions(@trip.from, @trip.to, mode: 'driving',alternatives: false)

    erb :"/passengers/book-driver.html"
  end

  post "/passenger/trip/:id/driver" do
    trip = Trip.find(params[:id])
    driver = Driver.find(params[:driver_id])
    trip.driver = driver 
    trip.save
    driver.reload
    redirect "/passenger/trips"
  end




  get "/passenger/trips" do 

    erb :"/passengers/trips.html"
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
