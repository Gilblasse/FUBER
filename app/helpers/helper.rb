class Helpers

    def self.logged_in?(session)
      !!session[:user_id]
    end

    def self.current_user(session)
      user = User.find(session[:user_id])
      Passenger.find_by(user: user) || Driver.find_by(user: user)
    end

    def self.user_dashboard(session)
      current_user = self.current_user(session)

      route = {"Passenger" => '/passenger/book-trip/new', "Driver" => '/driver/dashboard' }
      route[current_user.class.to_s]
    end


end