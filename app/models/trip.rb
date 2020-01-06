class Trip < ActiveRecord::Base
    belongs_to :driver
    belongs_to :passenger

    def self.measure
        distance = @trip[0][:legs][0][:distance][:text]
        num = distance.gsub(/[A-Za-z\s]/,"").to_f
        @measurement = distance.scan(/([A-Za-z])/).join
        @calc = {"ft"=> num,"mi"=> num * 5280}
    end

    def self.distance(passenger_location,drivers_set)
        # binding.pry
        Driver.all.each do |driver| 
            
            @trip = GMAPS.directions(driver.current_location,passenger_location,mode: 'driving',alternatives: false)
            
            measure
            
            leg = {
                ft: @calc[@measurement], 
                unit: @measurement,
                time: @trip[0][:legs][0][:duration][:text] ,
                geocode: @trip[0][:legs][0][:start_location].to_json
            }
            driver_leg = OpenStruct.new(leg)
            drivers = OpenStruct.new(driver: driver, leg: driver_leg)
            
            # Drivers = Struct.new(:driver, :leg)
            drivers_set << drivers
            drivers_set
        end 

    end
        
end