# how can this class be fixed to prevent future problems

class Flight
  # attr_accessor :database_handle # REMOVE

  def initialize(flight_number)
    @database_handle = Database.init
    @flight_number = flight_number
  end
end

# the problem is we are providing easy access to the @database_handle instance variable, which is just an implementation detail. there should be no need to access it
# if it is not removed, it may be used in real code, with any modifications to the class breaking that code