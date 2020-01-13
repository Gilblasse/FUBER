class PassengersController < ApplicationController

  set :drivers_set, []


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
      redirect "/passenger/trip/#{@active_trips[0].id}" 
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
    @trip = Trip.find(params[:id])
    @drivers = Driver.closest_drivers(@trip.from)
    @trip_leg = GMAPS.directions(@trip.from, @trip.to, mode: 'driving',alternatives: false)

    erb :"/passengers/book-driver.html"
  end

# ASSOCIATING DRIVER FOR TRIP
  post "/passenger/trip/:id/driver" do     
    trip = Trip.find(params[:id])
    driver = Driver.find(params[:driver_id])
    trip.driver = driver 
    trip.save
    driver.reload
    redirect "/passenger/trips"
  end



##########################
#    TRIP SECTION
##########################

# SHOW TRIP 
  get '/passenger/trip/:id' do 
    @stylesheet_link = "/stylesheets/passengers/dashboard.css"
    authenticate_user
    @trip = Trip.find(params[:id])
      
    erb :"/passengers/show-trip.html"
  end
  
  # ALL TRIPS 
  get '/passenger/trips' do 
    @passenger = authenticate_user
    erb :"/passengers/trips.html"
  end
  


  #######################
  # EDIT TRIP SECTION
  #######################

  # PRESENT EDIT FORM
  get '/passenger/trip/:id/edit' do 
    @passenger = authenticate_user
    @trip = Trip.find(params[:id])
    
    erb :"/passengers/edit-trip.html"
  end

  # Updating Trip
  patch "/passenger/trip/:id" do        
    trip = Trip.find(params[:id])
    trip.update(Hash[params.to_a[1..-2]])
    
    redirect "/passenger/trip/#{params[:id]}"
  end

  # Deleting Trip
  delete "/passenger/trip/:id" do        
    trip = Trip.find(params[:id]).destroy
    redirect "/passenger/trips"
  end




  ##########################
  #   REVIEWS SECTION
  ##########################

  # ALL REVIEWS
  get '/passenger/reviews' do 
    @stylesheet_link = "/stylesheets/passengers/dashboard.css"
    @passenger = authenticate_user

    erb :"/passengers/reviews.html"
  end

  # SHOW FORM TO CREATE NEW REVIEW 
  get "/passenger/reviews/:id" do 
    authenticate_user
    @trip = Trip.find_by(id: params[:id])

    erb :"/passengers/new_review.html"
  end

  # Create A Review 
  post "/passenger/reviews" do
    trip = Trip.find_by(id: params[:trip_id])
    if !trip.passenger.reviewed?(trip) && !params[:comment].empty?
      trip.passenger.add_review(trip.id,params[:comment],params[:stars][0])
    end

    redirect "/passenger/book-trip/new"
  end






    
  helpers do 

    def authenticate_user
      redirect "/login" if !Helpers.logged_in?(session)
      redirect "/not-found" if Helpers.current_user(session).class.to_s != "Passenger"
      Helpers.current_user(session)
    end
  
  end





end
