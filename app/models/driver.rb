class Driver < ActiveRecord::Base
    belongs_to :user
    has_many :trips, -> { readonly }
    has_many :passengers, :through => :trips

    attr_accessor :leg

    def dashboard
        '/driver/dashboard'
    end

    def self.closest_drivers(passenger_location)
        five_miles = 26411 #apporximate number of ft in 5 miles
        closest_drivers = self.all.select {|driver| driver.distance_from(passenger_location) }
        closest_drivers.sort_by { |driver| driver.leg[:ft]}
    end


    def distance_from(passenger_location)
        trip = GMAPS.directions(self.current_location,passenger_location,mode: 'driving',alternatives: false)
        distance = trip[0][:legs][0][:distance][:text]
        num = distance.gsub(/[A-Za-z\s]/,"").to_f
        measurement = distance.scan(/([A-Za-z])/).join

        calc = {"ft"=> num,"mi"=> num * 5280} #converts everthing to feet
        
        @leg = {
            ft: calc[measurement], 
            unit: measurement,
            time: trip[0][:legs][0][:duration][:text] ,
            geocode: trip[0][:legs][0][:start_location].to_json
        } 

    end

    def current_location
        address.sample
    end

    def address
        @addresses = [
            "1662 NY-300 #123, Newburgh, NY 12550","29-31 Garrisons Landing, Garrison, NY 10524",
            "2107 New South Post Rd, Highland Falls, NY 10928","127 Warren Landing Rd, Garrison, NY 10524",
            "26 E Main St, Pawling, NY 12564","142 Lakeside Dr, Pawling, NY 12564",
            "145 Main St, New Paltz, NY 12561","250 Main St, New Paltz, NY 12561",
            "679 Riverside Dr, New York, NY 10031","1 E 161 St, The Bronx, NY 10451",
            "945 Madison Ave, New York, NY 10021","62 Chelsea Piers, New York, NY 10011",
            "981 West Side Ave, Jersey City, NJ 07306","501 Jersey Ave, Jersey City, NJ 07302",
            "241-A Rockaway Pkwy, Brooklyn, NY 11212","1631-43 Pitkin Ave, Brooklyn, NY 11212",
            "7100 Shore Rd, Brooklyn, NY 11209","130 W Kingsbridge Rd, The Bronx, NY 10468",
            "5520 Broadway, The Bronx, NY 10463","5701 Arlington Ave, The Bronx, NY 10471",
            "5701 Arlington Ave, The Bronx, NY 10471","1200 Nepperhan Ave, Yonkers, NY 10703",
            "5 Barker Ave, White Plains, NY 10601","540 Saw Mill River Rd, Elmsford, NY 10523"
        ]
    end


end
