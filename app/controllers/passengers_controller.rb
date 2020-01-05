class PassengersController < ApplicationController

  # BOOK NEW TRIP FORM
  get "/passenger/book-trip/new" do
    @stylesheet_link = "/stylesheets/passengers/dashboard.css"
    @passenger = authenticate_user  
    
    erb :"/passengers/book-trip.html"
  end

  post "/passenger/book-trip" do      # CREATED NEW TRIP
    passenger = authenticate_user 
    trip = passenger.trips.create(params[:address])

    redirect "/passenger/book-trip/#{trip.id}/driver/new"
  end

  # post '/passenger/trip/2' do
  #   "Hello World"
  # end

  # EDIT A TRIP  -  PRESENT UPDATE FORM
  get '/passenger/trip/:id/edit' do 
    @passenger = authenticate_user
    @trip = Trip.find(params[:id])
    @drivers = Driver.closest_drivers(@trip.from)
    erb :"/passengers/edit-trip.html"
  end

  post "/passenger/trip/:id" do        # UPDATE TRIP |  Needs to be a Patch however for some reason patch is not working.
    trip = Trip.find(params[:id])
    driver =  Driver.find(params[:driver_id])
    trip.update(from: params[:address][:from] ,to: params[:address][:to],driver: driver)
    
    redirect "/passenger/trip/#{params[:id]}"
  end



  # SHOW TRIP 
  get '/passenger/trip/:id' do 
    @stylesheet_link = "/stylesheets/passengers/dashboard.css"
    authenticate_user
    @trip = Trip.find(params[:id])
    
    erb :"/passengers/show-trip.html"
  end


  # BOOK NEW DRIVER  - PRESENTING FORM
  get "/passenger/book-trip/:id/driver/new" do
    @stylesheet_link = "/stylesheets/passengers/dashboard.css"
    @passenger = authenticate_user 
    @trip = Trip.find(params[:id])
    @drivers = Driver.closest_drivers(@trip.from)
    @trip_leg = GMAPS.directions(@trip.from, @trip.to, mode: 'driving',alternatives: false)

    erb :"/passengers/book-driver.html"
  end

  post "/passenger/trip/:id/driver" do     # CREATED NEW DRIVER FOR TRIP
    trip = Trip.find(params[:id])
    driver = Driver.find(params[:driver_id])
    trip.driver = driver 
    trip.save
    driver.reload
    redirect "/passenger/trips"
  end

    # SHOW ALL TRIPS 
    get '/passenger/trips' do 
      # binding.pry
      @passenger = authenticate_user
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
