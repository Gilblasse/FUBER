ENV['SINATRA_ENV'] ||= "development"

require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "db/#{ENV['SINATRA_ENV']}.sqlite"
)

require './app/controllers/application_controller'
require_all 'app'
require 'ostruct'

# Setup global parameters
API_KEY = "AIzaSyBaJUNgMSEae4z_X1lRQI-2PjqwfamHNOk"
GoogleMapsService.configure do |config|
  config.key = API_KEY
  config.retry_timeout = 20
  config.queries_per_second = 10
end

# Initialize client using global parameters
GMAPS = GoogleMapsService::Client.new