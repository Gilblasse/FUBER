ENV["SINATRA_ENV"] ||= "development"

require_relative './config/environment'
require 'sinatra/activerecord/rake'


task 'console' do 
    Pry.start
end


namespace 'db' do

    desc "Removes data from tables and resets PK"
    task 'reset!' do 
        puts "Clean Database..."
        model_files = Dir.entries("app/models")

        tables = model_files[2..-1].map{|file| file[0...-3] }
        klasses = tables.map{|model| model.capitalize.constantize }
        klasses.each{|klass| klass.destroy_all }
        tables_pluralize = tables.map{|table| table.pluralize }

        tables_pluralize.each do |table|
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