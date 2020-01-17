require './config/environment'
require './app/controllers/application_controller.rb'

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

use Rack::MethodOverride
use TripsController
use ReviewsController
use DriversController
use PassengersController
use UsersController
run ApplicationController