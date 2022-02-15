require 'pry'

# GAME ORCHESTRATION
class TTTGame
  attr_reader :board, :human, :computer
  attr_accessor :current_marker, :first_to_move
  X_MARKER = 'X'
  O_MARKER ='O'

  def initialize
    @human = Player.new(nil)
    @computer = Player.new(nil)
    set_up_game
    @board = Board.new
  end

  def play
    clear
    display_welcome_message
    # set_up_game
    main_game
    display_goodbye_message
  end

  private

  def clear
    system 'clear'
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts
  end

  def set_up_game
    what_symbols
    who_goes_first
  end

  def what_symbols
    pick = ask_to_pick_symbols
    if pick.start_with?('y')
      pick_symbols
    else
      random_symbols
    end
  end

  def ask_to_pick_symbols
    puts "Do you want to pick your symbol?"
    pick = nil
    loop do
      pick = gets.chomp
      break if pick == 'y' || pick == 'n'
      puts "must be y or n"
    end
    pick
  end

  def pick_symbols
    puts "Do you want to play as X or O?"
    symbol = nil
    loop do
      symbol = gets.chomp.upcase
      break if symbol == X_MARKER || symbol == O_MARKER
      puts "must be X or O"
    end
    if symbol == X_MARKER
      human.marker = X_MARKER
      computer.marker = O_MARKER
    else
      human.marker = O_MARKER
      computer.marker = X_MARKER
    end
  end

  def random_symbols
    human.marker = [X_MARKER, O_MARKER].sample
    human.marker == X_MARKER ? computer.marker = O_MARKER : computer.marker = X_MARKER
  end

  def who_goes_first
    pick = ask_to_pick_starter
    pick.start_with?('y') ? pick_starter : random_starter
  end

  def ask_to_pick_starter
    puts "Do you want to pick who goes first?"
    pick = nil
    loop do
      pick = gets.chomp
      break if pick == 'y' || pick == 'n'
      puts "must be y or n"
    end
    pick
  end

  def pick_starter
    puts "Ok, would you like to go first or second? Please enter 1 or 2."
    answer = nil
    loop do
      answer = gets.chomp.to_i
      break if (1..2).include?(answer)
      puts "Please enter 1 or 2"
    end
    binding.pry
    case answer
    when 1 then @first_to_move = @human
    when 2 then @first_to_move = @computer
    end
    @current_marker = @first_to_move.marker
  end

  def random_starter
    @first_to_move = [@human, @computer].sample
    @current_marker = @first_to_move.marker
  end

  def main_game
    loop do
      display_board
      player_move
      display_result
      break unless play_again?
      reset
      display_play_again_message
    end
  end

  # Board Display Methods
  def display_board
    puts "You're a #{human.marker}"
    puts "The computer is a #{computer.marker}"
    display_scores
    puts
    board.draw
    puts
  end

  def display_scores
    puts "You've won #{human.score} games."
    puts "The computer has won #{computer.score} games."
    puts "It's your turn" if @current_marker == human.marker
  end

  # Player Choosing Moves Methods
  def player_move
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if human_turn?
    end
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = computer.marker
    else
      computer_moves
      @current_marker = human.marker
    end
  end

  def human_turn?
    @current_marker == human.marker
  end

  def human_moves
    puts "Chose a square (#{list_available_moves}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry invalid choice"
    end

    board[square] = human.marker
  end

  def computer_moves
    # binding.pry
    if board.unmarked_keys.include?(5)
      board[5] = computer.marker
    elsif board.best_move
      board[board.best_move] = computer.marker
    else
      board[choose_random_square] = computer.marker
    end
  end

  def choose_random_square
    board.unmarked_keys.sample
  end

  def list_available_moves
    joinor(board.unmarked_keys)
  end

  def joinor(arr, delimiter=', ', word='or')
    case arr.size
    when 0 then ''
    when 1 then arr.first
    when 2 then arr.join(" #{word} ")
    else
      arr[-1] = "#{word} #{arr.last}"
      arr.join(delimiter)
    end
  end

  def clear_screen_and_display_board(_clear_screen = true)
    clear
    display_board
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      display_human_win
    when computer.marker
      display_computer_win
    else
      puts "Its a tie"
    end
  end

  def display_human_win
    puts "You won"
    human.update_score(board.winning_marker)
  end

  def display_computer_win
    puts "You lost"
    computer.update_score(board.winning_marker)
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      puts "Must be y or n"
    end

    answer == 'y'
  end

  def reset
    board.reset
    first_to_move == human.marker ? computer.marker : human.marker
    clear
  end

  def display_play_again_message
    puts "Lets play again"
    puts
  end

  def display_goodbye_message
    puts "Thanks for playing TTT, seeya"
  end
end

class Board
  attr_reader :squares

  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @human_marker = human.marker
    @computer_marker = computer.marker
    @squares = {}
    reset
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  # will return winning marker or nil
  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def best_move
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if two_in_a_row?(squares)
       (if possible_win?(squares)
         return @squares.key(squares.select(&:unmarked?)[0])
       end)
      (if possible_loss?(squares)
         return @squares.key(squares.select(&:unmarked?)[0])
       end)
    end
    nil
  end

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end

  def two_in_a_row?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 2
    if markers.min == markers.max
      markers
    else
      false
    end
  end
  

  def possible_win?(squares)
    return if two_in_a_row?(squares) == false
    two_in_a_row?(squares).first == TTTGame::COMPUTER_MARKER
  end

  def possible_loss?(squares)
    return if two_in_a_row?(squares) == false
    two_in_a_row?(squares).first != TTTGame::HUMAN_MARKER
  end
end

class Square
  INITIAL_MARKER = ' '

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def marked?
    marker != INITIAL_MARKER
  end

  def unmarked?
    marker == INITIAL_MARKER
  end
end

class Player
  attr_accessor :score, :marker

  def initialize(marker)
    @marker = marker
    @score = 0
  end

  def update_score(winning_marker)
    self.score += 1 if winning_marker == @marker
  end
end

class Human < Player
end

class COmputer < Player
end

# RUN GAME
game = TTTGame.new
game.play
