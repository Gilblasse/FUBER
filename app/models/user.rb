class User < ActiveRecord::Base
    has_secure_password
    validates :email, uniqueness: true
    has_one :passenger
    has_one :driver

    def create_type(user_type)
        self.send("create_#{user_type}")
    end
end
