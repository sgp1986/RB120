class Animal
	def move
	end
end

class Fish < Animal
	def move
		"swim"
	end
end

class Cat < Animal
	def move
		"walk"
	end
end

class Sponge < Animal; end
class Coral < Animal; end

animals = [Fish.new, Cat.new, Sponge.new, Coral.new]
animals = animals.map { |animal| animal.move }
p animals