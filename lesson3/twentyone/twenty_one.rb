require 'pry'
require 'yaml'

PROMPTS = YAML.load_file("twenty_one.yml")

module Displayable
  YESNO = ['yes', 'y', 'no', 'n']
  def prompt(message)
    puts "==> #{message}"
  end

  def buffer_line
    puts
  end

  def enter_to_continue
    puts PROMPTS['continue']
    gets
  end

  def display_welcome
    game_intro
    sit_at_table
    welcome
  end

  def game_intro
    puts PROMPTS['intro']
    @limit = set_limit
    add_buy_in
    buffer_line
  end

  def sit_at_table
    puts format(PROMPTS['sit_down'], dealer.name)
    user.name = user.set_name
    buffer_line
  end

  def welcome
    puts format(PROMPTS['welcome'], user.name)
    enter_to_continue
  end

  def display_score
    puts format(PROMPTS['scoreboard'],
                @min, @max, user.score, dealer.name, dealer.score, user.chips)
    buffer_line
  end

  def show_flop
    user.show_flop
    dealer.show_flop
  end

  def show_cards
    user.show_hand
    dealer.show_hand
  end

  def display_result
    if user.total > dealer.total
      show_user_win
    elsif user.total < dealer.total
      show_dealer_win
    else
      show_push
    end
  end

  def show_user_win
    puts format(PROMPTS['user_win'],
                user.total, dealer.total, user.win, user.chips)
    user.score += 1
    buffer_line
  end

  def show_dealer_win
    puts format(PROMPTS['dealer_win'],
                dealer.total, user.total, user.current_bet, user.chips)
    buffer_line
    dealer.score += 1
  end

  def show_push
    puts format(PROMPTS['push'], dealer.total, user.current_bet, user.chips)
    buffer_line
  end

  def display_busted
    show_user_bust if user.busted?
    show_dealer_bust if dealer.busted?
  end

  def show_user_bust
    puts format(PROMPTS['user_bust'], user.name, user.chips)
    buffer_line
    dealer.score += 1
  end

  def show_dealer_bust
    puts format(PROMPTS['dealer_bust'], user.name, user.win, user.chips)
    buffer_line
    user.score += 1
  end

  def ask_to_play_again
    puts PROMPTS['ask_again']
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if YESNO.include?(answer)
      puts "Please enter (y)es or (n)o."
    end
    answer
  end

  def display_goodbye
    puts PROMPTS['goodbye']
  end

  def display_end_of_game
    puts PROMPTS['outro']
  end
end

module Hand
  def show_hand
    puts "---- #{name}'s Hand ----"
    cards.each do |card|
      puts "=> #{card}"
    end
    puts "=> Total: #{total}"
    puts
  end

  def total
    total = 0
    total = find_score(cards, total)

    # correct for aces
    cards.select(&:ace?).count.times do
      break if total <= 21
      total -= 10
    end

    total
  end

  def find_score(cards, total)
    cards.each do |card|
      total += if card.ace?
                 11
               elsif face_card?(card)
                 10
               else
                 card.face.to_i
               end
    end
    total
  end

  def face_card?(card)
    card.jack? || card.queen? || card.king?
  end

  def add_card(new_card)
    cards << new_card
  end

  def busted?
    total > 21
  end
end

module ChipTray
  BUY_IN = 100
  LOW_LIMIT = (5..25)
  MID_LIMIT = (25..50)
  HIGH_LIMIT = (50..100)
  LIMITS = ["low", "mid", "high"]

  def bet
    puts "You currently have $#{user.chips} in chips."
    puts "How much would you like to bet?"
    bet = nil
    loop do
      bet = gets.chomp.to_i
      break if bet_in_limit?(bet) && bet <= user.chips
      puts "please enter a bet between min and max limits."
    end
    user.chips -= bet
    bet
  end

  def win
    winning_bet = total == 21 ? @current_bet * 3 : @current_bet * 2

    self.chips += winning_bet
    winning_bet
  end

  def push
    self.chips += @current_bet
    @current_bet
  end

  def set_limit
    self.limit = input_table_limit
    case @limit
    when "low" then LOW_LIMIT
    when "mid" then MID_LIMIT
    when "high" then HIGH_LIMIT
    end
  end

  def input_table_limit
    limit = nil
    loop do
      limit = gets.chomp.downcase
      break if LIMITS.include?(limit)
      puts PROMPTS['no_limit']
    end
    limit
  end

  def bet_in_limit?(bet)
    betting_range = @limit
    betting_range.include?(bet)
  end

  def add_buy_in
    user.chips = @limit == HIGH_LIMIT ? BUY_IN * 5 : BUY_IN
  end
end

# Game Engine
class TwentyOne
  include ChipTray, Displayable
  attr_accessor :deck, :user, :dealer, :limit

  HIT = ['hit', 'h']
  STAY = ['stay', 's']
  HIT_STAY = HIT + STAY
  QUIT = 'q'

  def initialize
    @deck = Deck.new
    @user = User.new
    @dealer = Dealer.new
    @limit = nil
  end

  # Game Loop
  def start
    display_welcome
    @min = @limit.min
    @max = @limit.max
    clear_screen
    loop do
      intro_gameplay

      main_gameplay

      break if walk_away? == QUIT
      reset_hand
      if user.chips == 0
        play_again? ? reset_game : break
      end
    end
    display_goodbye
    display_end_of_game
  end

  private

  def intro_gameplay
    user.current_bet = bet
    clear_screen
    deal_cards
    show_flop
  end

  def main_gameplay
    if user.total == 21
      puts format(PROMPTS['blackjack'], user.win, user.chips)
    elsif player_turn == false
      show_cards
      display_result
    end
  end

  def clear_screen
    system 'clear'
    display_score
  end

  def reset_hand
    clear_screen
    if deck.remaining_cards < 10
      self.deck = Deck.new
      puts PROMPTS['shuffling']
      gets
    else
      @deck
    end
    user.cards = []
    dealer.cards = []
  end

  def reset_game
    self.deck = Deck.new
    user.cards = []
    dealer.cards = []
    add_buy_in
  end

  def deal_cards
    2.times do
      user.add_card(deck.deal_one)
      dealer.add_card(deck.deal_one)
    end
  end

  def player_turn
    user_turn
    if user.busted?
      display_busted
      return true
    end
    enter_to_continue
    clear_screen
    dealer_turn
    if dealer.busted?
      display_busted
      return true
    else
      clear_screen
    end
    false
  end

  def user_turn
    puts PROMPTS['user_turn']

    loop do
      puts PROMPTS['hit_or_stay']
      answer = choose_hit_or_stay

      STAY.include?(answer) ? break : hit_play
      break if user.busted?
    end
    stay_play unless user.busted?
  end

  def stay_play
    puts [PROMPTS['stay1'], PROMPTS['stay2'], PROMPTS['stay3']].sample
    buffer_line
  end

  def choose_hit_or_stay
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if HIT_STAY.include? answer
      puts PROMPTS['no_h_s']
    end
    answer
  end

  def hit_play
    puts [PROMPTS['hit1'], PROMPTS['hit2'], PROMPTS['hit3']].sample
    buffer_line

    user.add_card(deck.deal_one)
    user.show_hand
    puts
  end

  def dealer_turn
    start_of_dealer_turn

    loop do
      dealer_end_of_play ? break : dealer_hit
      break if dealer.busted?
    end
    dealer_stay unless dealer.busted?
  end

  def start_of_dealer_turn
    puts format(PROMPTS['dealer_turn'], user.total, dealer.name)
    buffer_line
    dealer.show_hand
  end

  def dealer_end_of_play
    dealer.total >= 17 && !dealer.busted?
  end

  def dealer_stay
    puts format(PROMPTS['dealer_stay'], dealer.total)
    sleep(2)
  end

  def dealer_hit
    puts format(PROMPTS['dealer_hit'], dealer.total, dealer.name)
    sleep(1.75)
    buffer_line
    dealer.add_card(deck.deal_one)
    dealer.show_hand
  end

  def walk_away?
    walk = nil
    loop do
      buffer_line
      puts "Press enter to continue, or press Q to leave the table."
      walk = gets.chomp.downcase
      break if walk.empty? || walk == 'q'
    end
    walk
  end

  def play_again?
    answer = ask_to_play_again

    answer.start_with?('y')
  end
end

class Player
  include Hand, ChipTray

  attr_accessor :name, :cards, :score

  def initialize
    @cards = []
    @name = nil
    @score = 0
  end
end

class User < Player
  attr_accessor :chips, :current_bet

  def initialize
    super
    @chips = 100
    @current_bet = nil
  end

  def set_name
    name = ''
    loop do
      name = gets.chomp.capitalize.strip
      break unless name.empty?
      puts PROMPTS['no_name']
    end
    self.name = name
  end

  def show_flop
    show_hand
  end
end

class Dealer < Player
  ROBOTS = ['Cindy', 'Billy', 'Julie', 'Sonny', 'Bobby']

  def initialize
    super
    set_name
  end

  def set_name
    self.name = ROBOTS.sample
  end

  def show_flop
    puts "---- #{name}'s Hand ----"
    puts cards.first.to_s
    puts " ?? "
    puts
  end
end

class Card
  SUITS = ['H', 'D', 'S', 'C']
  FACES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

  def initialize(suit, face)
    @suit = suit
    @face = face
  end

  def to_s
    "The #{face} of #{suit}"
  end

  def face
    case @face
    when 'J' then 'Jack'
    when 'Q' then 'Queen'
    when 'K' then 'King'
    when 'A' then 'Ace'
    else
      @face
    end
  end

  def suit
    case @suit
    when 'H' then 'Hearts'
    when 'D' then 'Diamonds'
    when 'S' then 'Spades'
    when 'C' then 'Clubs'
    end
  end

  def ace?
    face == 'Ace'
  end

  def king?
    face == 'King'
  end

  def queen?
    face == 'Queen'
  end

  def jack?
    face == 'Jack'
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    2.times do
      Card::SUITS.each do |suit|
        Card::FACES.each do |face|
          @cards << Card.new(suit, face)
        end
      end
    end

    scramble!
    cut!
  end

  def scramble!
    cards.shuffle!
  end

  def cut!
    cut = rand(10..20)
    @cards = @cards.reject.with_index do |_, idx|
      (0..cut).include?(idx)
    end
  end

  def remaining_cards
    @cards.size
  end

  def deal_one
    cards.pop
  end
end

game = TwentyOne.new
game.start
