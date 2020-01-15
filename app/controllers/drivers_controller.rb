class DriversController < ApplicationController

  ######################
  #     Dashboard
  ######################

  get "/driver/dashboard" do
    @stylesheet_link = "/stylesheets/passengers/dashboard.css"
    @driver = authenticate_user

    if @driver.is_available?
      map = GMAPS.directions(@driver.current_location,"181 mansion st poughkeepsie ny",mode: 'driving',alternatives: false)
      @driver_coord = map[0][:legs][0][:start_location]
      
      @trip = @driver.trips.detect{|trip| trip.status == "pending"}
      erb :"/drivers/dashboard.html"
    else 
      trip = @driver.current_trip
      redirect "/driver/trips/#{trip.id}"
    end
  end

  # Dismiss Alert 
  post "/driver/dashboard/notification/:id/dismiss" do
    driver = authenticate_user
    trip = driver.trips.detect {|trip| trip.id == params[:id].to_i}
    
    trip.driver = nil;
    trip.save
    driver.reload

    redirect "/driver/dashboard"
  end

  # Accept Alert
  post "/driver/dashboard/notification/:id/accept" do
    driver = authenticate_user
    trip = driver.trips.detect {|trip| trip.id == params[:id].to_i}
  
    trip.status = "in route" 
    trip.save
    driver.reload
    redirect "/driver/trips/#{params[:id]}"
  end



  ##########################
  #      TRIP SECTION
  ##########################

  # SHOW ALL TRIPS 
  get "/driver/trips" do 
    @driver = authenticate_user
    erb :"/drivers/trips.html"
  end

  # View Active Trip 
  get "/driver/trips/:id" do 
    @driver = authenticate_user
    if params[:id] == "no_active_trips"
       redirect "/driver/dashboard"
    else  
      @trip = @driver.find_my_trip(params[:id])
      redirect "/not-found" if @trip.nil?

      @leg_info = @driver.distance_from(@trip.from)
      @instructions = @driver.driving_instructions

      erb :"/drivers/show_trip.html"
    end
    
  end

  # Update Trip Status 
  patch "/driver/trips/:id/:status/edit" do 
    driver = authenticate_user
    trip = driver.find_my_trip(params[:id])
    trip.status = params[:status]
    trip.save 
    redirect "/driver/reviews/#{params[:id]}" if params[:status] == "completed"

    if params[:status] == "completed" || params[:status] =="canceled"
      redirect "/driver/dashboard"
    else
      redirect "/driver/trips/#{params[:id]}"
    end
  end




  ##########################
      # REVIEW SECTION
  ##########################

  # SHOW ALL REVIEWS
  get "/driver/reviews" do 
    @driver = authenticate_user
    erb :"/drivers/reviews.html"
  end

# SHOW FORM TO CREATE NEW REVIEW 
  get "/driver/trips/:id/reviews" do 
    @driver = authenticate_user
    @trip = driver.find_my_trip(params[:id])
    redirect "/not-found" if @trip.nil?
    
    erb :"/drivers/new_review.html"
  end

  # Create Review 
  post "/driver/reviews" do
    driver = authenticate_user
    trip = driver.find_my_trip(params[:id])
    
    if !trip.driver.reviewed?(trip) && !params[:comment].empty?
      trip.driver.add_review(trip.id,params[:comment],params[:stars][0])
    end

    redirect "/driver/dashboard"
  end






  helpers do 

    def authenticate_user
      redirect "/login" if !Helpers.logged_in?(session)
      redirect "/not-found" if Helpers.current_user(session).class.to_s != "Driver"
      Helpers.current_user(session)
    end
  
  end




end
