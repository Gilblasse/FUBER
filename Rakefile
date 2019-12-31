ENV["SINATRA_ENV"] ||= "development"

require_relative './config/environment'
require 'sinatra/activerecord/rake'


task 'console' do 
    Pry.start
end

namespace 'db' do

    desc "Removes data from tables and resets PK"
    task 'reset!' do 
        tables = ["users","passengers","drivers"]
        models = ["User","Passenger","Driver"]

        klasses = models.map {|model| model.constantize }
        klasses.each{|klass| klass.destroy_all }

        tables.each do |table|
            ActiveRecord::Base.connection.execute("DELETE from sqlite_sequence where name = '#{table}'")
        end

        puts "Database is clean..."
    end

    desc "Resets data then seeds new data"
    task 'reload_seed_data' do 
        Rake::Task["db:reset!"].invoke
        Rake::Task["db:seed"].invoke
    end
    
end