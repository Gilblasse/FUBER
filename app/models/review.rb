class Review < ActiveRecord::Base
    belongs_to :reviewable, polymorphic: true
    belongs_to :trip
    # belongs_to driver
    # belongs_to passesnger
end