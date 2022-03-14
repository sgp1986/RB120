module AModule
THAT = "bye"
  module Swim
    THIS = "Hi"
    def enable_swimming
      @can_swim = true
    end
  end
end

class Dog
  include AModule

  def swim
    "swimming!" if @can_swim
  end
end

class Bulldog < Dog; end

teddy = Dog.new

# p Bulldog::THIS
p Bulldog::THAT