class Helpers


    def self.logged_in?(session)
      !!session[:user_id]
    end

    def self.current_user(session)
      User.find(session[:user_id])
    end

    def self.user_dashboard(session)
      user = self.current_user(session)
      route = {passenger: '/passenger/dashboard', driver: '/driver/dashboard' }
      route[user.user_type.to_sym]
    end


end