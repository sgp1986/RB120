require 'yaml'
require 'abbrev'

PROMPTS = YAML.load_file('rps_bonus_prompts.yml')

def prompt(message)
  puts "==> #{message}"
end

def clear_screen
  system('clear')
end

YES = ['yes', 'y']
NO = ['no', 'n']

class GameEngine
  def initialize
    @user = User.new
    @computer = Computer.new
    @winning_score = 6
    @winners = []
    @round_winner = nil
    @in_a_row = 1
  end

  def play
    display_welcome_message
    display_rules_prompt
    loop do # full game loop
      one_round
      display_game_winner
      break unless play_again?
      reset_game
    end
    display_goodbye_message
  end

  private

  attr_reader :user, :computer, :winning_score
  attr_accessor :winners, :round_winner, :in_a_row

  def one_round
    loop do # round loop
      display_round_screen
      user.choose
      computer.choose
      display_round_moves
      display_round_winner
      game_winner? ? break : prompt_to_continue
    end
  end

  def display_welcome_message
    clear_screen
    prompt PROMPTS['welcome']
    prompt PROMPTS['opponent'] + computer.name.to_s
  end

  def print_rules
    PROMPTS['rules'].split('').each do |c|
      print c
      sleep(0.03)
    end
    first = true
    prompt_to_continue(first)
  end

  def display_rules_prompt
    prompt PROMPTS['see_rules']
    read_rules = nil
    loop do
      read_rules = gets.chomp
      break if YES.include?(read_rules) || NO.include?(read_rules)
      prompt PROMPTS['invalid_yn']
    end

    return unless read_rules.start_with?('y')
    print_rules
  end

  def display_user_stats
    prompt "#{user.name}'s Score: #{user.score} | History: "\
    + user.history.map(&:capitalize).join(', ')
  end

  def display_computer_stats
    prompt "#{computer.name}'s Score: #{computer.score} | History: "\
    + computer.history.map(&:capitalize).join(', ')
  end

  def display_stats
    display_user_stats
    display_computer_stats

    if @winners.empty?
      puts
    elsif in_a_row > 1
      prompt "The last rounds winner was: #{@winners.last} "\
             "- #{in_a_row} in a row!"
    else
      prompt "The last rounds winner was: #{@winners.last}"
    end
  end

  def display_round_screen
    clear_screen
    prompt "RPScSpL: First to #{winning_score} wins!"
    display_stats
    puts
  end

  def moves_intro
    prompt "#{user.name} has selected their move."
    sleep(0.65)
    prompt "#{computer.name} is thinking..."
    sleep(0.65)
  end

  def countdown
    countdown = PROMPTS['countdown']

    countdown.split.each do |word|
      prompt "#{word} "
      sleep(0.75)
    end
  end

  def display_moves
    prompt "#{user.name} chose #{user.move}."
    prompt "#{computer.name} chose #{computer.move}."
    sleep(0.75)
  end

  def display_round_moves
    moves_intro
    countdown
    display_moves
  end

  def player_wins(player, other_player)
    self.round_winner = player.name
    player.move.display_verb(other_player.move)
    prompt "Congrats to #{player.name} for winning this round!"
    player.score += 1
  end

  def display_round_winner
    if user.move > computer.move
      player_wins(user, computer)
    elsif computer.move > user.move
      player_wins(computer, user)
    else
      prompt PROMPTS['tie']
      self.round_winner = "No one."
    end
    update_game
  end

  def update_game
    add_winner
    add_rounds
  end

  def update_in_a_row
    if @winners.last == @round_winner
      @in_a_row += 1
    else
      @in_a_row = 1
    end
  end

  def add_winner
    update_in_a_row
    @winners << @round_winner
  end

  def add_rounds
    user.history << user.move.value
    computer.history << computer.move.value
  end

  def prompt_to_continue(first=false)
    if first == false
      prompt PROMPTS['continue']
    else
      prompt PROMPTS['first_round']
    end
    gets
  end

  def game_winner?
    user.score == @winning_score || computer.score == @winning_score
  end

  def display_game_winner
    if user.score == @winning_score
      prompt user.name.to_s + PROMPTS['won']
    else
      prompt computer.name.to_s + PROMPTS['won']
    end
  end

  def reset_game
    user.history = []
    computer.history = []
    user.score = 0
    computer.score = 0
    @winners = []
  end

  def play_again?
    answer = nil
    loop do
      puts PROMPTS['play_again']
      answer = gets.chomp
      break if YES.include?(answer) || NO.include?(answer)
      puts PROMPTS['invalid_yn']
    end

    return true if answer.downcase.start_with?('y')
    false
  end

  def display_goodbye_message
    prompt PROMPTS['goodbye'] + "#{user.name}!"
  end
end

class Player
  attr_accessor :name, :move, :score, :history

  def initialize
    set_name
    @move = nil
    @score = 0
    @history = []
  end
end

class User < Player
  def set_name
    name = nil
    loop do
      prompt PROMPTS['enter_user_name']
      name = gets.chomp.strip
      break unless name.empty?
      prompt PROMPTS['invalid_name']
    end
    self.name = name.capitalize
  end

  def choose
    choice = nil
    prompt PROMPTS['choose_move']
    loop do
      choice = gets.chomp
      break if Move::ABBREVIATIONS.include?(choice)
      prompt "please enter one of the following :#{Move::VALID_MOVES}"
    end
    choice = Move::ABBREVIATIONS[choice]
    self.move = Move.convert_move_to_class[choice].new
  end
end

class Computer < Player
  def ask_to_set_name(answer)
    loop do
      prompt PROMPTS['ask_comp_name']
      answer = gets.chomp.strip
      break if YES.include?(answer) || NO.include?(answer)
      prompt PROMPTS['invalid_yn']
    end
    answer
  end

  def enter_computer_name(name)
    loop do
      prompt PROMPTS['enter_comp_name']
      name = gets.chomp
      break unless name.empty?
      prompt PROMPTS['invalid_name']
    end
    name
  end

  def set_name
    answer = nil
    answer = ask_to_set_name(answer)
    if answer.start_with?('y')
      name = nil
      name = enter_computer_name(name)
      self.name = name.capitalize
    else
      self.name = ['R2D2', 'C3P0', 'Robot', 'Windows', 'Mac', 'Linux'].sample
      personality
    end
  end

  def choose
    choice = Move::VALID_MOVES.sample
    self.move = Move.convert_move_to_class[choice].new
  end

  def personality
    case name
    when 'R2D2' then Move::VALID_MOVES << "rock"
    when 'C3P0' then Move::VALID_MOVES << "scissors"
    when 'Robot' then Move::VALID_MOVES << "paper"
    when 'Windows' then Move::VALID_MOVES << "lizard"
    when 'Mac' then Move::VALID_MOVES << "spock"
    end
  end
end

class Move
  VALID_MOVES = %w(rock paper scissors lizard spock)
  ABBREVIATIONS = Abbrev.abbrev(VALID_MOVES)

  attr_reader :value

  def initialize(value)
    @value = value
  end

  def self.convert_move_to_class
    { "rock" => Rock,
      "paper" => Paper,
      "scissors" => Scissors,
      "spock" => Spock,
      "lizard" => Lizard }
  end

  def >(other_move)
    beats.keys.include?(other_move.value)
  end

  def display_verb(other_move)
    prompt "#{value.capitalize} " \
            "#{beats[other_move.to_s].sample.capitalize} " \
            "#{other_move.value.capitalize}!"
    sleep(1.0)
  end

  def to_s
    @value
  end
end

class Rock < Move
  attr_reader :value, :beats

  def initialize
    @value = 'rock'
    @beats = {
      "scissors" => ['smashes', 'obliterates'],
      "lizard" => ['crushes', 'destroys']
    }
  end
end

class Paper < Move
  attr_reader :value, :beats

  def initialize
    @value = 'paper'
    @beats = {
      "rock" => ['covers'],
      "spock" => ['disproves', 'papercuts']
    }
  end
end

class Scissors < Move
  attr_reader :value, :beats

  def initialize
    @value = 'scissors'
    @beats = {
      "paper" => ['cuts', 'shreds'],
      "lizard" => ['decapitates', 'slices']
    }
  end
end

class Spock < Move
  attr_reader :value, :beats

  def initialize
    @value = 'spock'
    @beats = {
      "rock" => ['vaporizes', 'ray guns'],
      "scissors" => ['melts', 'teleports']
    }
  end
end

class Lizard < Move
  attr_reader :value, :beats

  def initialize
    @value = 'lizard'
    @beats = {
      "paper" => ['bites', 'eats'],
      "spock" => ['poisons', 'chomps']
    }
  end
end

GameEngine.new.play
