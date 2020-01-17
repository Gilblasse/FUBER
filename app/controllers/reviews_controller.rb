class ReviewsController < ApplicationController

  ##########################
  #    REVIEW SECTION
  ##########################


  # ALL TRIPS 
  get '/:user/reviews' do 
    @user = authenticate_user(params[:user])

    erb :"/#{params[:user].pluralize}/reviews.html"
  end

  # SHOW REVIEW FORM
  get "/:user/trips/:id/reviews/new" do 
    @user = authenticate_user(params[:user])
    @trip = @user.find_my_trip(params[:id])

    redirect "/not-found" if @trip.nil?
        
    erb :"/#{params[:user].pluralize}/new_review.html"
  end

  # CREATED NEW REVIEW
  post "/:user/reviews" do
    user = authenticate_user(params[:user])
    trip = user.find_my_trip(params[:trip_id])
      
    if !trip.send("#{params[:user]}").reviewed?(trip) && !params[:comment].empty?
      trip.send("#{params[:user]}").add_review(trip.id,params[:comment],params[:stars][0])
    end
  
    redirect user_dashboard
  end














    helpers do 

        def authenticate_user(user_path)
          redirect "/login" if !Helpers.logged_in?(session)
          redirect "/not-found" if user_path.capitalize != Helpers.current_user(session).class.to_s
          Helpers.current_user(session)
        end

        def user_dashboard
          Helpers.user_dashboard(session)
        end

      end


end