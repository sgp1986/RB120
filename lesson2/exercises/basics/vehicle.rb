# prob1 - create two classes, truck and car, that inherit from vehicle
# prob2 - change the code so that creating a new truck automatically invokes start engine
# prob3 - allow truck to accept a second argument apon instantiation named bed type, and implement the modification that car continues to only accept one arg
# prob4 - move start_engine to vehicle and modify it in truck to append the string
# prob5 - create a Towable module containing a tow method and include in Truck
# prob - create a module named Transportation that contains all 3 classes

module Towable
  def tow
    "I can tow a trailer!"
  end
end

module Transportation
  class Vehicle
    attr_reader :year

    def initialize(year)
      @year = year
    end

    def start_engine
      "Ready to go!"
    end
  end

  class Truck < Vehicle
    include Towable

    attr_accessor :bed_type

    def initialize(year, bed_type)
      super(year)
      @bed_type = bed_type
    end

    def start_engine(speed)
      super() + " Drive #{speed} please!"
    end

  end

  class Car < Vehicle
  end
end


truck1 = Transportation::Truck.new(1994, "Short")
puts truck1.year
puts truck1.bed_type
puts truck1.start_engine('fast')
puts truck1.tow

car1 = Transportation::Car.new(2006)
puts car1.year