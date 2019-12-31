class UsersController < ApplicationController

  # Displays Sign Up Page
  get "/signup" do
    @stylesheet_link = "/stylesheets/users/signup.css"
    erb :"/users/signup.html"
  end

  # POST: /users
  post "/users" do
    redirect '/login' if User.find_by(email: params[:email])
    redirect "/signup" if params[:name].empty? || params[:email].empty? || params[:password].empty?
    User.create(params)
    redirect '/login'
  end

   # Displays Login Page 
   get "/login" do
    @stylesheet_link = "/stylesheets/users/login.css"
    erb :"/users/login.html"
  end

  post "/login" do
    @stylesheet_link = "/stylesheets/users/login.css"
    user = User.find_by(email: params[:email]).try(:authenticate, params[:password])
    if !!user 
      session[:user_id] = user.id
      redirect '/dashboard'
    else 
      redirect '/login'
    end  

  end

  get '/dashboard' do 
    erb :"/users/dashboard.html"
  end

  # GET: /users/5
  get "/users/:id" do
    erb :"/users/show.html"
  end

  # GET: /users/5/edit
  get "/users/:id/edit" do
    erb :"/users/edit.html"
  end

  # PATCH: /users/5
  patch "/users/:id" do
    redirect "/users/:id"
  end

  # DELETE: /users/5/delete
  delete "/users/:id/delete" do
    redirect "/users"
  end
end
