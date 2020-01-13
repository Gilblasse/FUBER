class Passenger < ActiveRecord::Base
    belongs_to :user
    has_many :trips
    has_many :drivers, :through => :trips
    has_many :reviews, as: :reviewable

    def dashboard 
        '/passenger/book-trip/new'
    end

    def add_review(trip_id,comment,stars=0)
        stars = stars.to_i
        trip = Trip.find(trip_id)

        return nil if !stars.between? 0,5
                
        passenger_review = self.reviews.create(comment: comment, stars: stars)
        trip.reviews << passenger_review
        passenger_review
    end

    def reviewed?(trip)
        trip.reviews.any?{|review| review.reviewable == self }
    end

    def rating 
        stars = driver_reviews.map{|r| r.stars}
        total = stars.reduce{|star,sum| star + sum }
        if total
            avg = (total.to_f / stars.size).ceil(2)
        else
            5
        end
    end

    def driver_reviews 
        self.trips.map{|trip| trip.reviews.select{|review| review.reviewable == trip.driver }}.flatten
    end

    def reviewed?(trip)
        trip.reviews.any?{|review| review.reviewable == self }
    end

    def active_trips
        self.trips.reject{|trip| trip.status.downcase == "canceled" || trip.status.downcase == "completed" }
    end

end
