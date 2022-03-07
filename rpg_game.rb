=begin
+ The application has information about every player. They all have a name, health, strength and intelligence.

When each player is created, it gets:

+ a health value of 100
+ a random strength value (between 2 and 12, inclusive)
+ a random intelligence value (between 2 and 12 inclusive)
+ The random values are determined by a call to a #roll_dice method that cannot be accessed outside of the class.

+ You can set and change the strength and intelligence in the constructors. 
+ However, once an object is constructed, the values may not change.

+ Health can only be changed by the methods #heal and #hurt. 
+ Each method accepts one argument, the amount of change to the health. 
+ The #heal increases the health value by the indicated amount, 
+ while the #hurt decreases the value.

+ A player can be a warrior, a paladin, a magician, or a bard.

+ Warriors receive an additional 2 points of strength when they're created. The resulting strength range is thus between 4 and 14, inclusive.

+ Magicians receive an additional 2 points of intelligence when they're created. The resulting intelligence range is thus between 4 and 14, inclusive.

+ Warriors and paladins have the ability to wear armor. They need access to 2 additional methods: #attach_armor and #remove_armor.

+ Paladins, magicians and bards can cast spells. They need access to a #cast_spell method, that accepts one argument, spell.

+ Bards are a special type of magician that can also create potions. They have a #create_potion method.
=end

module Armorable
  def attach_armor
    puts "Putting on my armor."
  end

  def remove_armor
    puts "Taking off my armor."
  end
end

module Magic
  def cast_spell(spell)
    puts "#{name} casts #{spell}!"
  end
end

class Player
  def initialize(name, strength=roll_dice, intelligence=roll_dice)
    @name = name
    @health = 100
    @strength = strength
    @intelligence = intelligence
  end

  attr_reader :name

  def heal(amount)
    self.health += amount
  end

  def hurt(amount)
    self.health -= amount
  end

  def to_s
    <<~STATS
    Name: #{name}
    Class: #{self.class}
    Health: #{health}
    Strength: #{strength}
    Intelligence: #{intelligence}
    STATS
  end

  private

  attr_accessor :health, :strength, :intelligence

  def roll_dice
    rand(2..12)
  end
end

class Warrior < Player
  include Armorable

  def initialize(name, strength=roll_dice, intelligence=roll_dice)
    super(name, strength, intelligence)
    self.strength += 2
  end
end

class Paladin < Player
  include Armorable, Magic
end

class Magician < Player
  include Magic

  def initialize(name, strength=roll_dice, intelligence=roll_dice)
    super(name, strength, intelligence)
    self.intelligence += 2
  end
end

class Bard < Magician
  def create_potion
    puts "Bottling up my potion."
  end
end

class Weapon
  def initialize
    @damage
    @accuracy
    
end

Class Sword < Weapon
end

Class Bow < Weapon
end

Class Staff < Weapon
end

Class Wand < Staff
end


require 'pry'; pry.start