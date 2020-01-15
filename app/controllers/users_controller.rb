class UsersController < ApplicationController

  set :message, {}

  # Displays Sign Up Page
  get "/signup" do
    @stylesheet_link = "/stylesheets/users/signup.css"
    settings.message.clear
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
    settings.message.clear
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

  get '/failure' do
    redirect '/login' if settings.message[:email].nil?
    <<-ERROR_MESG 
      Email: #{settings.message[:email]}
      <br>#{settings.message[:error][:email][0]}
      <br> 
      <a href='/signup'>Sign Up</a>
    ERROR_MESG
  end


  
  helpers do 

    def authenticate_form
      redirect "/signup" if params[:user][:name].empty? || params[:user][:email].empty? || params[:user][:password].empty?
    end

    def create_user_type
      user = User.new(params[:user])
      
      if user.valid? 
        user.save
        user. create_type(params[:type])
      else
        settings.message[:error] = user.errors.messages
        settings.message[:email] = params[:user][:email]
        redirect '/failure'
      end
    end


    def user_dashboard
      Helpers.user_dashboard(session)
    end

    def logged_in?
      Helpers.logged_in?(session)
    end
  
  end


end
