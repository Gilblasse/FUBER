class UsersController < ApplicationController

  # Displays Sign Up Page
  get "/signup" do
    @stylesheet_link = "/stylesheets/users/signup.css"
    redirect user_dashboard if logged_in?
    erb :"/users/signup.html"
  end

  post "/signup" do
    authenticate_form
    create_user_type
    redirect '/login'
  end

   # Displays Login Page 
   get "/login" do
    @stylesheet_link = "/stylesheets/users/login.css"
    redirect user_dashboard if logged_in?
    erb :"/users/login.html"
  end

  post "/login" do
    user = User.find_by(email: params[:email]).try(:authenticate, params[:password])

    if !!user 
      session[:user_id] = user.id
      redirect user_dashboard
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

    def create_user_type
      user = User.create(params[:user])
      params[:type] == "passenger" ? user.create_passenger : user.create_driver
    end

    def user_dashboard
      Helpers.user_dashboard(session)
    end

    def logged_in?
      Helpers.logged_in?(session)
    end
  
  end


end
