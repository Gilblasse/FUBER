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
      @action_type = ["dismiss","accept"]
      erb :"/drivers/dashboard.html"
    else 
      trip = @driver.current_trip
      redirect "/driver/trips/#{trip.id}"
    end
  end

  # Dismiss / Accept  Trip 
  post "/driver/dashboard/notifications" do
    driver = authenticate_user
    trip = driver.trips.detect {|trip| trip.id == params[:id].to_i}
    action_type = {"accept"=>["status","in route"],"dismiss"=>["driver",nil]}

    trip.send("#{action_type[params[:status]].first}=", action_type[params[:status]].last) 
    trip.save
    driver.reload
    
    if params[:status] == "accept"
      redirect "/driver/trips/#{params[:id]}"
    else
      redirect "/driver/dashboard"
    end   
    
  end











  helpers do 

    def authenticate_user
      redirect "/login" if !Helpers.logged_in?(session)
      redirect "/not-found" if Helpers.current_user(session).class.to_s != "Driver"
      Helpers.current_user(session)
    end
  
  end




end
