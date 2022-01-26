# write the classes and methods necessary to run the code and print the output

class Owner
  attr_accessor :name, :pets

  def initialize(name)
    @name = name
    @pets = []
  end

  def number_of_pets
    @pets.count
  end

  def add_pet(pet)
    @pets << pet
  end

  def print_pets
    puts pets
  end
end

class Pet
  attr_accessor :species, :name

  def initialize(species, name)
    @species = species
    @name = name
  end

  def to_s
    "a #{@species} named #{@name}"
  end
end

class Shelter
  attr_accessor :unadopted_pets, :owners

  def initialize
    @owners = {}
    @unadopted_pets = {}
  end

  def shelter_animal(pet)
    @unadopted_pets[pet.name] = {species: pet.species, name: pet.name}
  end

  def adopt(owner, pet)
    owner.add_pet(pet)
    @owners[owner.name] ||= owner
  end

  def print_adoptions
    @owners.each_pair do |name, owner|
      puts "#{name} has adopted the following pets:"
      owner.print_pets
      puts
    end
  end
end



butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')

shelter = Shelter.new
shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)

# shelter.print_adoptions
# puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
# puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."

# P Hanson has adopted the following pets:
# a cat named Butterscotch
# a cat named Pudding
# a bearded dragon named Darwin

# B Holmes has adopted the following pets:
# a dog named Molly
# a parakeet named Sweetie Pie
# a dog named Kennedy
# a fish named Chester

# P Hanson has 3 adopted pets.
# B Holmes has 4 adopted pets.


asta = Pet.new('dog', 'Asta')
laddie = Pet.new('dog', 'Laddie')

shelter.shelter_animal(asta)
shelter.shelter_animal(laddie)
puts shelter.unadopted_pets
p '-'
puts shelter.owners
sprice = Owner.new("S Price")
shelter.adopt(sprice, asta)
shelter.print_adoptions
puts shelter.unadopted_pets