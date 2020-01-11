class PassengersController < ApplicationController

  set :drivers_set, []

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

  post "/passenger/book-trip" do      # CREATED NEW TRIP
    passenger = authenticate_user 
    if params[:address].any?{|k,v| v.empty?}
      redirect "/passenger/book-trip/new"
    else
      trip = passenger.trips.create(params[:address])
      redirect "/passenger/book-trip/#{trip.id}/driver/new"
    end
  end
  

  # EDIT A TRIP  -  PRESENT UPDATE FORM
  get '/passenger/trip/:id/edit' do 
    @passenger = authenticate_user
    @trip = Trip.find(params[:id])
    
    erb :"/passengers/edit-trip.html"
  end

  patch "/passenger/trip/:id" do        # UPDATE TRIP |  Needs to be a Patch however for some reason patch is not working.
    trip = Trip.find(params[:id])
    trip.update(Hash[params.to_a[1..-2]])
    
    redirect "/passenger/trip/#{params[:id]}"
  end


  delete "/passenger/trip/:id" do        # UPDATE TRIP |  Needs to be a Patch however for some reason patch is not working.
    trip = Trip.find(params[:id]).destroy
    redirect "/passenger/trips"
  end



  # BOOK NEW DRIVER  - PRESENTING FORM
  get "/passenger/book-trip/:id/driver/new" do
    @stylesheet_link = "/stylesheets/passengers/dashboard.css"
    @passenger = authenticate_user 
    @trip = Trip.find(params[:id])
    # Trip.distance_from(@trip.from,settings.drivers_set)
    
    # @drivers = settings.drivers_set
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


    # SHOW TRIP 
    get '/passenger/trip/:id' do 
      @stylesheet_link = "/stylesheets/passengers/dashboard.css"
      authenticate_user
      @trip = Trip.find(params[:id])
      
      erb :"/passengers/show-trip.html"
    end
  

    # ALL TRIPS 
    get '/passenger/trips' do 
      # binding.pry
      @passenger = authenticate_user
      erb :"/passengers/trips.html"
    end
  


    # ALL REVIEWS
    get '/passenger/reviews' do 
      @stylesheet_link = "/stylesheets/passengers/dashboard.css"
      @passenger = authenticate_user
      erb :"/passengers/reviews.html"
    end


    # SHOW REVEIW
    get '/passenger/reviews/:id' do 
      @stylesheet_link = "/stylesheets/passengers/dashboard.css"
      @passenger = authenticate_user
      @review = Review.find(params[:id])
      erb :"/passengers/show_review.html"
    end


    







    
  helpers do 

    def authenticate_user
      redirect "/login" if !Helpers.logged_in?(session)
      redirect "/not-found" if Helpers.current_user(session).class.to_s != "Passenger"
      Helpers.current_user(session)
    end
  
  end





end
