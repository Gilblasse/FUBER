class UsersController < ApplicationController

  # Displays Sign Up Page
  get "/signup" do
    @stylesheet_link = "/stylesheets/users/signup.css"
    redirect Helpers.user_dashboard(session) if Helpers.logged_in?(session)
    erb :"/users/signup.html"
  end

  post "/signup" do
    authenticate_form
    user = User.create(params[:user])
    create_user_type(user)
    redirect '/login'
  end

   # Displays Login Page 
   get "/login" do
    @stylesheet_link = "/stylesheets/users/login.css"
    redirect Helpers.user_dashboard(session) if Helpers.logged_in?(session)
    erb :"/users/login.html"
  end

  post "/login" do
    user = User.find_by(email: params[:email]).try(:authenticate, params[:password])

    if !!user 
      session[:user_id] = user.id
      redirect Helpers.user_dashboard(session)
    else 
      redirect '/login'
    end  
  end

  # Log Out
  get "/logout" do
    session.clear
    redirect '/'
  end



  
  helpers do 

    def authenticate_form
      redirect '/login' if User.find_by(email: params[:email])
      redirect "/signup" if params[:user][:name].empty? || params[:user][:email].empty? || params[:user][:password].empty?
    end

    def create_user_type(user)
      params[:type] == "passenger" ? Passenger.create(user: user) : Driver.create(user: user)
    end
  
  end


end
