=begin
  RULES
  Rock, Paper, Scissors, Lizard, Spock!
  SCISSORS cuts PAPER covers ROCK crushes LIZARD poisons
  SPOCK smashes SCISSORS decapitates LIZARD eats PAPER
  disproves SPOCK vaporizes ROCK crushes SCISSORS

  GAME
  player makes a choice from 5 options, the computer makes a choice from those
   same options, the two choices are compared, the winner is declared and the
    next round begins until the winning score is reached

  Nouns
  player, user, computer, choice, winner
  Verbs
  make a choice, choices compared, winner declared, round begins

  CLASSES
  Game Engine
    start game
    allow moves
    display moves
    display round winner
    start new round
    display game winner
    end game
  Player
    make a choice
    compare choices
  User < Player
    user name
      user input
    user score
    user history
  Computer < Player
    computer name
      array of names to sample
    computer personality
      each name likes a certain move the most
    computer score
    computer history
  Score
    user score
    computer score
    winning score
  Move History
    users history
    computers history

  NOTES
  if User and Computer are both subbing from Player, they cant sublcass
    from Score or History, module? or state?
=end

class Player
  attr_accessor :move, :name, :score

  def initialize
    @move = nil
    set_name
    @score = 0
  end
end

class Human < Player
  def set_name
    n = ""
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a name"
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, or scissors:"
      choice = gets.chomp
      break if Move::VALUES.include? choice
      puts "Sorry, invalid choice"
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class Move
  VALUES = ['rock', 'paper', 'scissors']

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def >(other_move)
    rock? && other_move.scissors? ||
      paper? && other_move.rock? ||
      scissors? && other_move.paper?
  end

  def <(other_move)
    rock? && other_move.paper? ||
      paper? && other_move.scissors? ||
      scissors? && other_move.rock?
  end

  def to_s
    @value
  end
end

class Rule
  def initialize; end
end

def compare(move1, move2); end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors #{human.name.capitalize}!"
  end

  def display_score
    puts "#{human.name}'s score: #{human.score}"
    puts "#{computer.name}'s score: #{computer.score}"
  end

  def display_moves
    puts "#{human.name} chose: #{human.move}."
    puts "#{computer.name} chose: #{computer.move}."
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
      human.score += 1
    elsif human.move < computer.move
      puts "#{computer.name} won!"
      computer.score += 1
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer
      puts "Sorry, must be y or n."
    end

    return true if answer.downcase == 'y'
    false
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors.Goodbye!"
  end

  def play
    display_welcome_message
    loop do
      display_score
      human.choose
      computer.choose
      display_moves
      display_winner
      break if human.score == 10 || computer.score == 10
    end
    display_goodbye_message
  end
end

RPSGame.new.play
