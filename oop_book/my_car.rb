module TruckbedLoadable
  def truckbed_load
    puts "I'm loading material into the truckbed"
  end
end

class Vehicle
  attr_accessor :color
  attr_reader :year, :model
  @@number_of_vehicles = 0

  def initialize(y, m, c)
    @@number_of_vehicles += 1
    @year = y
    @model = m
    @color = c
    @current_speed = 0
  end

  def self.number_of_vehicles
    puts "This program has created #{@@number_of_vehicles} vehicles"
  end

  def self.gas_mileage(liter, kilometers)
    puts "#{kilometers / liter} kilometers per liter of gas"
  end

  def spray_paint(paint)
    self.color = paint
    puts "Your new #{paint} paint job looks great!"
  end

  def speed_up(number)
    @current_speed += number
    puts "You push the gas pedal and accelerate #{number} kph."
  end

  def brake(number)
    @current_speed -= number
    puts "You hit the brake pedal and decelerate #{number} kph."
  end

  def current_speed
    puts "You are now going #{@current_speed} kph."
  end

  def shut_off_car
    @current_speed = 0
    puts "Lets park this bad boy!"
  end

  def age
    "Your #{self.model} is #{years_old} years old."
  end

  private

  def years_old
    Time.now.year - self.year
  end
end

class MyTruck < Vehicle
  include TruckbedLoadable
  NUMBER_OF_DOORS = 2

  def to_s
    "Your #{year} #{model} truck is the color #{color}"
  end
end

class MyCar < Vehicle
  NUMBER_OF_DOORS = 4
  
  def to_s
    "Your #{year} #{model} car is the color #{color}"
  end
end

class Student
  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def better_grade_than?(rival)
    grade > rival.grade
  end

  protected

  def grade
    @grade
  end
end

lumina = MyCar.new(1997, 'chevy lumina', 'white')
# lumina.speed_up(20)
# lumina.current_speed
# lumina.speed_up(20)
# lumina.current_speed
# lumina.brake(20)
# lumina.current_speed
# lumina.brake(20)
# lumina.current_speed
# lumina.shut_off_car
# lumina.current_speed
# lumina.color = 'black'
# puts lumina.color
# puts lumina.year
# lumina.spray_paint('chrome')

# MyCar.gas_mileage(13, 351)

# puts lumina

tacoma = MyTruck.new(2022, 'toyota tacoma', 'grey')

# puts tacoma
# Vehicle.number_of_vehicles
# tacoma.truckbed_load

# puts "--MyTruck method lookup path--"
# puts MyTruck.ancestors
# puts "--MyCar method lookup path--"
# puts MyCar.ancestors
# puts "--Vehicle Lookup Path--"
# puts Vehicle.ancestors

# lumina.speed_up(20)
# lumina.current_speed
# lumina.speed_up(20)
# lumina.current_speed
# lumina.brake(20)
# lumina.current_speed
# lumina.brake(20)
# lumina.current_speed
# lumina.shut_off_car
# lumina.current_speed

# tacoma.speed_up(50)
# tacoma.current_speed

# puts lumina.age
# puts tacoma.age

joe = Student.new("Joe", 89)
bob = Student.new("Bob", 90)

puts "well done!" if joe.better_grade_than?(bob)