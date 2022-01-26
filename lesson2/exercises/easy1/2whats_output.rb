class Pet
  attr_reader :name

  def initialize(name)
    @name = name.to_s
  end

  def to_s
    "My name is #{@name.upcase}!"
  end
end

# name = 'Fluffy'
# fluffy = Pet.new(name)
# p fluffy.name
# # FLUFFY, My name is FLUFFY // wrong, outputs Fluffy
# p fluffy
# puts fluffy
# # <gibberish @name = 'FLUFFY'> //  wrong, outputs My name is FLUFFY!
# p fluffy.name
# # FLUFFY, My name is FLUFFY
# p name
# # FLUFFY

# why?
# instantiating fluffy assigns @name to the string inside the name variable, "Fluffy". so fluffy.name returns Fluffy
# calling p on fluffy returns the gibberish, however calling puts on fluffy calls to_s on fluffy, which mutates the string to upcasing Fluffy and returning the string sentance, which is printed to the screen with puts
# as the @name has now been mutated, calling fluffy.name again now prints out FLUFFY
# and calling the getter method name, which returns @name, printing it out with p/puts prints out @name which is now FLUFFY

# fix the class so there are no surprises when printing

# further exploration- what would happen in this case

name = 42
fluffy = Pet.new(name)
name += 1
p '-----'
p fluffy.name
puts fluffy.name
p '-----'
p fluffy
puts fluffy
p '-----'
p fluffy.name
puts fluffy.name
p '-----'
p name
puts name
p '-----'
p fluffy.name

# instantiation - variable name is initialized to the integer 42. variable fluffy is initialized to a new Pet object using name as a pointer to the integer 42. name is then reassigned to itself plus 1, so now name = 43. as name is not the same as the @name inside the pet class, name has been changed but @name has not and still stores the integer 42
# first round- thanks to the .to_s in the initialize method, fluffy.name returns 42 as a string
# second round- p fluffy returns the object states, showing @name = "42" and puts fluffy calls .to_s so following the custom .to_s method, it prints out the custom string sentence My name is 42! (upcase is not used as you cannot capitalize a number)
# third round- printing out fluffy.name is the same again
# fourth round- printing out name is printing out the variable name, which has been changed to 43. this is why it is dangerous to have multiple variables/methods with the same name