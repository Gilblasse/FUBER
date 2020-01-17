class PassengersController < ApplicationController


  ##########################
  # BOOKING NEW TRIP SECTION
  ##########################

  # BOOK NEW TRIP FORM
  get "/passenger/book-trip/new" do
    @stylesheet_link = "/stylesheets/passengers/dashboard.css"
    @passenger = authenticate_user  
    @active_trips = @passenger.active_trips 

    if @active_trips.empty?
      erb :"/passengers/book-trip.html"
    else
      redirect "/passenger/trips/#{@active_trips[0].id}" 
    end
    
  end

  # CREATED NEW TRIP
  post "/passenger/book-trip" do      
    passenger = authenticate_user 
    if params[:address].any?{|k,v| v.empty?}
      redirect "/passenger/book-trip/new"
    else
      trip = passenger.trips.create(params[:address])
      redirect "/passenger/book-trip/#{trip.id}/driver/new"
    end
  end
  


  ##########################
   # BOOKING DRIVER SECTION
  ##########################

# BOOK NEW DRIVER FORM
  get "/passenger/book-trip/:id/driver/new" do
    @stylesheet_link = "/stylesheets/passengers/dashboard.css"
    @passenger = authenticate_user 
    @trip = @passenger.find_my_trip(params[:id])
    @drivers = Driver.closest_drivers(@trip.from)
    @trip_leg = GMAPS.directions(@trip.from, @trip.to, mode: 'driving',alternatives: false)

    erb :"/passengers/book-driver.html"
  end

# ASSOCIATING DRIVER FOR TRIP
  post "/passenger/trips/:id/driver" do     
    passenger = authenticate_user 
    trip = passenger.find_my_trip(params[:id])
    driver = Driver.find(params[:driver_id])
    trip.driver = driver 
    trip.save
    driver.reload
    redirect "/passenger/trips/#{trip.id}"
  end












  
    
  helpers do 

    def authenticate_user
      redirect "/login" if !Helpers.logged_in?(session)
      redirect "/not-found" if Helpers.current_user(session).class.to_s != "Passenger"
      Helpers.current_user(session)
    end
  
  end





end
