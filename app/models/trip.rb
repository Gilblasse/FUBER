class Trip < ActiveRecord::Base
    belongs_to :driver
    belongs_to :passenger
    has_many :reviews 

end