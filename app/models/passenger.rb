class Passenger < ActiveRecord::Base
    belongs_to :user
    has_many :trips
    has_many :drivers, :through => :trips


    def dashboard 
        '/passenger/book-trip/new'
    end
end
