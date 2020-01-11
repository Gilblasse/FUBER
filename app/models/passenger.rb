class Passenger < ActiveRecord::Base
    belongs_to :user
    has_many :trips
    has_many :drivers, :through => :trips
    has_many :reviews, as: :reviewable

    def dashboard 
        '/passenger/book-trip/new'
    end

    def add_review(trip_id,comment,stars=0)
        trip = Trip.find(trip_id)
        return "You already made a review" if trip.reviews.any?{|review| review.reviewable == self }
        return "Star count must be a number between 0 - 5" if !stars.between? 0,5

        passenger_review = self.reviews.create(comment: comment, stars: stars)
        trip.reviews << passenger_review
        passenger_review
    end

end
