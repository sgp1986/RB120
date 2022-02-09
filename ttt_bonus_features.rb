require 'yaml'

PROMPTS = YAML.load_file("ttt_prompts.yml")

module Setable
  X_MARKER = "X"
  O_MARKER = "O"
  YES_NO = ['yes', 'y', 'no', 'n']

  def pick_board_size
    prompt PROMPTS['board_size']
    board_size = nil
    loop do
      board_size = gets.chomp.to_i
      break if (3..9).include?(board_size) && board_size.odd?
      prompt PROMPTS['invalid_size']
    end
    board_size
  end

  def set_human_marker
    pick = ask_to_pick_marker
    pick.start_with?('y') ? pick_marker : random_marker
  end

  def ask_to_pick_marker
    prompt PROMPTS['ask_marker']
    pick = nil
    loop do
      pick = gets.chomp.downcase
      break if YES_NO.include?(pick)
      prompt PROMPTS['invalid_input']
    end
    pick
  end

  def pick_marker
    prompt PROMPTS['marker']
    marker = nil
    loop do
      marker = gets.chomp.upcase
      break if marker == X_MARKER || marker == O_MARKER
      prompt PROMPTS['invalid_marker']
    end
    marker
  end

  def random_marker
    [X_MARKER, O_MARKER].sample
  end

  def set_computer_marker
    human.marker == X_MARKER ? O_MARKER : X_MARKER
  end

  def set_first_player
    pick = ask_to_pick_starter
    pick.start_with?('y') ? pick_starter : random_starter
  end

  def ask_to_pick_starter
    prompt PROMPTS['ask_starter']
    pick = nil
    loop do
      pick = gets.chomp.downcase
      break if YES_NO.include?(pick)
      prompt PROMPTS['invalid_input']
    end
    pick
  end

  def pick_starter
    prompt PROMPTS['starter']
    pick = nil
    loop do
      pick = gets.chomp.to_i
      break if (1..2).include?(pick)
      prompt PROMPTS['invalid_starter']
    end
    @first_to_move = pick == 1 ? human.marker : computer.marker

    @current_marker = @first_to_move
  end

  def random_starter
    @first_to_move = [X_MARKER, O_MARKER].sample
    @current_marker = @first_to_move
  end
end

module Displayable
  def prompt(message)
    puts "TicTacToe>> #{message}"
  end

  def buffer_line
    puts("")
  end

  def display_welcome_message
    prompt PROMPTS['welcome']
    buffer_line
  end

  def display_board
    prompt PROMPTS['your_marker'] + human.marker
    prompt PROMPTS['comp_marker'] + computer.marker
    buffer_line
    display_scores
    buffer_line
    board.draw_rows
    buffer_line
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_scores
    prompt "You've won #{human.score} games."
    prompt "The computer has won #{computer.score} games."
    buffer_line
    display_board_keys
    buffer_line
  end

  def display_board_keys
    puts "The key for each square is:"
    board.rows.each do |row|
      p row
    end
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      display_winner(human)
    when computer.marker
      display_winner(computer)
    else
      prompt PROMPTS['tie']
    end
  end

  def display_winner(player)
    prompt "#{player} won!"
    player.update_score(board.winning_marker)
  end

  def display_play_again_message
    prompt PROMPTS['again']
    buffer_line
  end

  def display_goodbye_message
    prompt PROMPTS['goodbye']
  end
end

class TTTGame
  include Setable, Displayable

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(set_human_marker, "You")
    @computer = Player.new(set_computer_marker, "The PC")
    @first_to_move = set_first_player
    @current_marker = @first_to_move
  end

  def play
    clear
    display_welcome_message
    main_game
    display_goodbye_message
  end

  private

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

  def clear
    system "clear"
  end

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
    prompt PROMPTS['choose'] + "(#{list_available_moves})"
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      prompt PROMPTS['invalid_square']
    end

    board[square] = human.marker
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

  def computer_moves
    board[computer_choice] = computer.marker
  end

  def computer_choice
    if middle_square_open?
      find_middle_square
    elsif find_best_move(@computer)
      find_best_move(@computer)
    elsif find_best_move(@human)
      find_best_move(@human)
    else
      @board.unmarked_keys.sample
    end
  end

  def middle_square_open?
    board.squares[find_middle_square].unmarked?
  end

  def find_middle_square
    middle_row = board.board_size / 2
    middle_col = middle_row
    board.rows[middle_row][middle_col]
  end

  def open_square(line)
    line.each do |square|
      return square if board.squares[square].marker == Square::INITIAL_MARKER
    end
    nil
  end

  def find_best_move(player)
    board_line = select_board_line(player)
    return nil if board_line.empty?
    open_square(board_line)
  end

  def select_board_line(player)
    board.winning_lines.select do |line|
      squares = board.squares.values_at(*line)
      row_a_threat?(squares, player)
    end.flatten
  end

  def row_a_threat?(squares, player)
    threat = board.board_size * 0.5
    row_almost_full(squares).count(player.marker) > threat
  end

  def row_almost_full(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    markers
  end

  def play_again?
    answer = nil
    loop do
      prompt PROMPTS['ask_again']
      answer = gets.chomp.downcase
      break if YES_NO.include?(answer)
      prompt PROMPTS['invalid_input']
    end

    answer.start_with?('y')
  end

  def reset
    board.reset
    @first_to_move = if @first_to_move == human.marker
                       computer.marker
                     else
                       human.marker
                     end
    @current_marker = @first_to_move
    clear
  end
end

class Board
  include Setable, Displayable

  attr_reader :squares, :ten_key, :rows, :cols, :diagonals, :winning_lines
  attr_accessor :board_size

  def initialize
    @squares = {}
    @board_size = pick_board_size
    reset
    @rows = fill_rows
    @cols = fill_cols
    @diagonals = fill_diagonals
    @winning_lines = @rows + @cols + @diagonals
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def draw_rows
    rows_hash = {}
    (0...@rows.size).each do |num|
      rows_hash[num + 1] = rows[num]
    end

    rows_hash.each do |row, cols|
      if row == 1
        puts ' _____' * @board_size
      end
      print "|"
      print '     |' * @board_size
      puts
      print "|"
      cols.each do |col|
        print "  #{@squares[col]}  |"
      end
      puts
      print "|"
      print '_____|' * @board_size
      puts
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def reset
    (1..@board_size**2).each { |key| @squares[key] = Square.new }
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    full_lines = full_line?
    identical?(full_lines)
  end

  private
  
  def fill_rows
    rows = []
    idx = 0
    cols = @board_size

    loop do
      rows << @squares.keys[idx, cols]
      idx += cols
      break if idx >= @squares.keys.size
    end
    rows
  end

  def fill_cols
    cols = []

    (0...@rows.size).each do |col_idx|
      new_row = (0...@rows.size).map { |row_index| @rows[row_index][col_idx] }
      cols << new_row
    end
    cols
  end

  def left_to_right_diagonal
    diagonals = Array.new

    (0...@rows.size).each do |col_idx|
      diagonals << @rows[col_idx][col_idx]
    end
    diagonals
  end

  def right_to_left_diagonal
    diagonals = Array.new

    idx = @rows[0].size - 1
    (0...@rows.size).each do |col_idx|
      diagonals << @rows[col_idx][idx]
      idx -= 1
    end
    diagonals
  end

  def fill_diagonals
    diag1 = left_to_right_diagonal
    diag2 = right_to_left_diagonal
    [diag1, diag2]
  end

  def full_line?
    @winning_lines.select do |line|
      line.all? do |col|
        @squares[col].marker != Square::INITIAL_MARKER
      end
    end
  end

  def identical?(full_lines)
    markers = full_lines.map do |line|
      line.map do |square|
        @squares[square].marker
      end
    end
    winning_marker = markers.select do |line|
      line.min == line.max
    end.flatten
    return winning_marker[0] unless winning_marker.empty?
    nil
  end
end

class Square
  INITIAL_MARKER = " "

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_reader :marker, :name
  attr_accessor :score

  def initialize(marker, name)
    @marker = marker
    @name = name
    @score = 0
  end

  def update_score(winning_marker)
    self.score += 1 if winning_marker == @marker
  end

  def to_s
    @name
  end
end

game = TTTGame.new
game.play
