=begin
Design a Sports Team (Author Unknown...thank you!)

+- Include 4 players (attacker, midfielder, defender, goalkeeper)
+- All the players’ jersey is blue, except the goalkeeper, his jersey is white with blue stripes
+- All players can run and shoot the ball.
- Attacker should be able to lob the ball
- Midfielder should be able to pass the ball
- Defender should be able to block the ball
- The referee has a whistle. He wears black and is able to run and whistle.
=end

module Movable
  def running
    "running!"
  end

class Player
  include Movable

  def initialize
    @jersey = 'blue'
  end

  def shoot_ball
    "shooting the ball!"
  end
end

class Attacker < Player
  def lob_ball
    "lobbing the ball!"
  end
end

class Midfielder < Player
  def pass_ball
    "passing the ball!"
  end
end

class Defender < Player
  def block_ball
    "blocking the ball!"
  end
end

class Goalie < Player
  def initialize
    @jersey = 'white and blue stripes'
  end
end

class Referee
  include Movable
  
  def initialize
    @whistle = true
    @jersey = black
  end

  def blow_whistle
    "blowing the whistle!"
  end
end