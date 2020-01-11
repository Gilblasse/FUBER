puts "Seeding Data..."
1.times do 
    user = User.create(name: "Ivery Blasse", email: "vrgilchrist@gmail.com" , password: "destiny" ).create_passenger
    user.trips.create(from: "181 Mansion st Pougkeepsie NY", to: "216 Church St Pougkeepsie NY")
end

15.times do 
    User.create(name: Faker::Name.unique.name, email: Faker::Internet.unique.email , password: "destiny" ).create_driver
end

puts "Seeding Completed"