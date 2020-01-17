class TripsController < ApplicationController

  ##########################
  #    TRIP SECTION
  ##########################

  # ALL TRIPS 
  get '/:user/trips' do 
    @user = authenticate_user(params[:user])
    erb :"/#{params[:user].pluralize}/trips.html"
  end
  
  
  # SHOW TRIP 
    get "/:user/trips/:id" do 
      @stylesheet_link = "/stylesheets/passengers/dashboard.css"
      @user = authenticate_user(params[:user])
      @trip = @user.find_my_trip(params[:id])
      
      if @user.class.to_s == "Driver" && params[:id] == "no_active_trips"
        redirect "/driver/dashboard"
      end

      redirect "/not-found"  if @trip.nil?

      erb :"/#{params[:user].pluralize}/show-trip.html"
    end
    
    
  
  
    #######################
    # EDIT TRIP SECTION
    # (driver is only responsible to update trip status)
    #######################
  
    # PRESENT EDIT FORM - ONLY PASSENGER
    get '/passenger/trips/:id/edit' do 
      @passenger = authenticate_user("passenger")
      @trip = @passenger.find_my_trip(params[:id])
      redirect "/not-found" if @trip.nil?
      
      erb :"/passengers/edit-trip.html"
    end
  
    # Deleting Trip - ONLY PASSENGER
    delete "/passenger/trips/:id" do
      passenger = authenticate_user("passenger")
      trip = passenger.find_my_trip(params[:id]).destroy        
  
      redirect "/passenger/trips"
    end
  

      # Update Trip Status 
    patch "/:user/trips/:id" do 
      user = authenticate_user(params[:user]) 
      trip = user.find_my_trip(params[:id])
      user_type = user.class.to_s.downcase
      
      trip.update(Hash[params.to_a[1..-3]])
       
      redirect "/#{user_type}/trips/#{params[:id]}/reviews/new" if params[:status] == "Completed"

      redirect "/#{user_type}/trips/#{params[:id]}"
      
    end



  
  
  



    helpers do 

        def authenticate_user(user_path)
          redirect "/login" if !Helpers.logged_in?(session)
          redirect "/not-found" if user_path.capitalize != Helpers.current_user(session).class.to_s
          Helpers.current_user(session)
        end

      end
   

  
  end
  