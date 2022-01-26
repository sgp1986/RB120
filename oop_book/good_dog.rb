# class GoodDog
#   attr_accessor :name, :height, :weight

#   def initialize(n, h, w)
#     @name = n
#     @height = h
#     @weight = w
#   end

#   def speak
#     "#{name} says arf!"
#   end

#   def change_info(n, h, w)
#     self.name = n
#     self.height = h
#     self.weight = w
#   end

#   def info
#     "#{name} weighs #{weight} and is #{height} tall."
#   end
# end



# sparky = GoodDog.new("Sparky", "12 inches", "10 lbs")
# puts sparky.speak
# puts sparky.info
# # sparky.name = "Spartacus"
# # puts sparky.name

# fido = GoodDog.new("Fido", "1.5 ft", "25 lbs")
# puts fido.speak
# puts fido.info

# sparky.change_info("Spartacus", "2 ft", "45 lbs")
# puts sparky.info
# --------------------------------------
# class GoodDog
#   @@number_of_dogs = 0

#   def initialize
#     @@number_of_dogs += 1
#   end

#   def self.total_number_of_dogs
#     @@number_of_dogs
#   end
# end

# puts GoodDog.total_number_of_dogs

# dog1 = GoodDog.new
# dog2 = GoodDog.new

# puts GoodDog.total_number_of_dogs
# --------------------------------------
# class GoodDog
#   DOG_YEARS = 7

#   attr_accessor :name, :age

#   def initialize(n, a)
#     @name = n
#     @age = a * DOG_YEARS
#   end

#   def to_s
#     "This dog's name is #{name} and it is #{age} in dog years."
#   end
# end

# sparky = GoodDog.new("Sparky", 4)
# puts sparky
# p sparky
# ---------------------------------------
# INHERITANCE
# class Animal
# 	def speak
# 		"Hello!"
# 	end
# end

# class GoodDog < Animal
#   attr_accessor :name

#   def initialize(n)
#     self.name = n
#   end

#   def speak
#     super + " From GoodDog class"
#   end
# end

# class Cat < Animal
# end

# sparky = GoodDog.new("Sparky")
# paws = Cat.new
# puts sparky.speak
# puts paws.speak
# ------------------------------------------
# class Animal
#   attr_accessor :name

#   def initialize(name)
#     @name = name
#   end
# end

# class GoodDog < Animal
#   def initialize(color)
#     super
#     @color = color
#   end
# end

# class BadDog < Animal
#   def initialize(age, name)
#     super(name)
#     @age = age
#   end
# end

# p BadDog.new(2, "bear")

# bruno = GoodDog.new("brown")
# p bruno
# ------------------------------------------
# module Swimmable
#   def swim
#     "I'm swimming!"
#   end
# end

# class Animal; end

# class Fish < Animal
#   include Swimmable
# end

# class Mammal < Animal
# end

# class Cat < Mammal
# end

# class Dog < Mammal
#   include Swimmable
# end

# sparky = Dog.new
# neemo = Fish.new
# paws = Cat.new

# p sparky.swim
# p neemo.swim
# p paws.swim
# --------------------------------------------
# METHOD LOOKUP PATH
# module Walkable
#   def walk
#     "I'm walking."
#   end
# end

# module Swimmable
#   def swim
#     "I'm swimming."
#   end
# end

# module Climbable
#   def climb
#     "I'm climbing"
#   end
# end

# class Animal
#   include Walkable

#   def speak
#     "I'm an animal, and I speak!"
#   end
# end

# class GoodDog < Animal
#   include Swimmable
#   include Climbable
# end
# -------------------------------------------------
# module Mammal
#   class Dog
#     def speak(sound)
#       p "#{sound}"
#     end
#   end

#   class Cat
#     def say_name(name)
#       p "#{name}"
#     end
#   end
# end

# # call classes in a module by appending the class name to the module name with two colons ::

# buddy = Mammal::Dog.new
# kitty = Mammal::Cat.new
# buddy.speak("Arf")
# kitty.say_name('kitty')
# -------------------------------------------------
# module Mammal
#   # ... code

#   def self.some_out_of_place_method(num)
#     num ** 2
#   end
# end
# -------------------------------------------------
class GoodDog
  DOG_YEARS = 7

  attr_accessor :name, :age

  def initialize(n, a)
    self.name = n
    self.age = a
  end

  private

  def human_years
    age * DOG_YEARS
  end
end

sparky = GoodDog.new("Sparky", 4)
sparky.human_years