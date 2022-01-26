# prob2 - create empty class
# prob3 - create an object assigned to variable kitty
# prob4 - add an initialize method that prints "I'm a cat!" when new object initialized
# prob5 - add a parameter to initialize that provides a name for the cat object. use an isntance variable to print a greeting with the provided name
# prob6 - move the greeting from initialize to an instance method #greet
# prob7 - add a getter method named name and invote it in place of @name in greet
# prob8 - add a setter method and change the name to Luna
# prob9 - change to shorthand (attr_reader & attr_writer to attr_accessor)
# prob10- create a module named Walkable that contains a walk method that prints to screen, include it in Cat
# OOP2
# prob1 - make a class method that prints to screen
# prob2 - add an instance method named rename that renames kitty when invoked
# prob3 - add a method identify that returns its calling object
# prob4 - add 2 methods, ::generic_greeting and #personal_greeting

module Walkable
  def walk
    puts "Let's go for a walk!"
  end
end

class Cat
  include Walkable
  
  attr_accessor :name

  @@total_cats = 0
  COLOR = "purple"

  def initialize(name)
    @name = name
    @@total_cats += 1
  end

  def personal_greeting
    puts "Hello! My name is #{name} and I'm a #{COLOR} cat!"
  end

  def self.generic_greeting
    puts "Hello! I'm a cat!"
  end

  def rename(new_name)
    self.name = new_name
  end

  def identify
    self
  end

  def self.speak
    puts "Meow!"
  end

  def self.total
    puts @@total_cats
  end

  def to_s
    "I'm #{name}!"
  end
end

# kitty = Cat.new("Sophie")
# kitty.greet
# puts kitty.name
# kitty.name = "Luna"
# kitty.greet
# kitty.walk
# Cat.generic_greeting
# kitty.class.generic_greeting
# kitty.rename("Chloe")
# kitty.greet
# p kitty.identify
# Cat.speak
# kitty.speak
kitty1 = Cat.new("Sophie")
kitty2 = Cat.new("Luna")
# Cat.total
kitty1.personal_greeting
puts kitty2