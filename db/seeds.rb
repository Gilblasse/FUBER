15.times do 
    User.create(name: Faker::Name.unique.name, email: Faker::Internet.unique.email , password: "destiny" ).create_driver
    # User.create(name: "Ivery Blasse", email: "vrgilchrist@gmail.com" , password: "destiny" ).create_passenger
end