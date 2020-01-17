class Helpers

    def self.logged_in?(session)
      !!session[:user_id]
    end

    def self.current_user(session)
      user = User.find(session[:user_id])
      self.klasses.find{|klass| klass.find_by(user: user.id) }.find_by(user: user)
    end

    def self.user_dashboard(session)
      current_user = self.current_user(session)
      current_user.dashboard
    end

    def self.klasses
      model_files = Dir.entries("app/models")
      selected_models = model_files[2..-1].reject{|file| file == "user.rb" }
      models = selected_models.map{|file| file[0...-3] }
      klasses = models.map{|model| model.capitalize.constantize }

      klasses.select{|klass| klass.column_names.include? "user_id" }
    end
    
    
end