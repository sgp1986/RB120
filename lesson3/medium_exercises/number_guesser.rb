class GuessingGame
  def play
    @remaining_guesses = 7
    @number = rand(1..100)
    @guess = nil
    loop do
      display_remaining_guesses
      get_number_guess
      break if winning_number? || remaining_guesses == 0
      display_low_or_high
    end
    display_result
  end

  private

  attr_accessor :guess, :remaining_guesses
  attr_reader :number

  def display_remaining_guesses
    puts "You have #{remaining_guesses} guesses remaining."
  end

  def get_number_guess
    print "Enter a number between 1 and 100: "
    loop do
      @guess = gets.chomp.to_i
      break if valid_number?
      print "Invalid guess. "
    end
    puts "That's the number!" if guess == number
    self.remaining_guesses -= 1
  end

  def valid_number?
    (1..100).include?(guess)
  end

  def winning_number?
    guess == number
  end

  def display_low_or_high
    puts guess > number ? "Your guess is too high." : "Your guess is too low."
  end

  def display_result
    puts guess == number ? "You won!" : "You have no more guesses. You lost."
  end
end

game = GuessingGame.new
game.play
game.play
