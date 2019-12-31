class PassengersController < ApplicationController

  # GET: /passengers
  get "/passengers" do
    erb :"/passengers/index.html"
  end

  # GET: /passengers/new
  get "/passengers/new" do
    erb :"/passengers/new.html"
  end

  # POST: /passengers
  post "/passengers" do
    redirect "/passengers"
  end

  # GET: /passengers/5
  get "/passengers/:id" do
    erb :"/passengers/show.html"
  end

  # GET: /passengers/5/edit
  get "/passengers/:id/edit" do
    erb :"/passengers/edit.html"
  end

  # PATCH: /passengers/5
  patch "/passengers/:id" do
    redirect "/passengers/:id"
  end

  # DELETE: /passengers/5/delete
  delete "/passengers/:id/delete" do
    redirect "/passengers"
  end
end
