require './config/environment'
require './app/controllers/application_controller.rb'

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end


use TripsController
use DriversController
use PassengersController
use UsersController
use Rack::MethodOverride
run ApplicationController