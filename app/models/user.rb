class User < ActiveRecord::Base
    has_secure_password
    validates :email, uniqueness: true
    has_one :passenger
    has_one :driver

    def create_type(user_type)
        self.send("create_#{user_type}")
    end

    def abbreviate_name
        name_arry = self.name.split(" ")
        first_name = name_arry.first
        last_initial = name_arry.last.chars[0]
        "#{first_name.capitalize} #{last_initial.capitalize}."
    end
end
