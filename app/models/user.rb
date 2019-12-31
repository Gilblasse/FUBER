class User < ActiveRecord::Base
    has_secure_password
    has_many :passengers
    has_many :drivers
end
