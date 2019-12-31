class UsersController < ApplicationController

  # Displays Sign Up Page
  get "/signup" do
    @stylesheet_link = "/stylesheets/users/signup.css"
    erb :"/users/signup.html"
  end

  post "/signup" do
    redirect '/login' if User.find_by(email: params[:email])
    redirect "/signup" if params[:name].empty? || params[:email].empty? || params[:password].empty?

    user = User.create(params.to_a[0...-1].to_h)
    params[:type] == "passenger" ? Passenger.create(user: user) : Driver.create(user: user)
    redirect '/login'
  end

   # Displays Login Page 
   get "/login" do
    @stylesheet_link = "/stylesheets/users/login.css"
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


end
