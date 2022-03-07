require 'set'

class MinilangError < StandardError; end
class BadTokenError < MinilangError; end
class EmptyStackError < MinilangError; end

class Minilang
  ACTIONS = Set.new %w(PUSH ADD SUB MULT DIV MOD POP PRINT)

  def initialize(program)
    @program = program
  end

  def eval
    @stack = []
    @register = 0
    @program.split.each { |token| eval_token(token) }
  rescue MinilangError => error
    puts error.message
  end

  private

  def eval_token(token)
    if ACTIONS.include?(token)
      send(token.downcase)
    elsif token =~ /\A[-+]?\d+\z/
      @register = token.to_i
    else
      raise BadTokenError, "Invalid token: #{token}"
    end
  end

  def push
    @stack.push(@register)
  end

  def pop
    raise EmptyStackError, "Empty stack!" if @stack.empty?
    @register = @stack.pop
  end

  def add
    @register += pop
  end

  def div
    @register /= pop
  end

  def mod
    @register %= pop
  end

  def mult
    @register *= pop
  end

  def sub
    @register -= pop
  end

  def print
    puts @register
  end
end

Minilang.new('PRINT').eval
puts "---------------"
Minilang.new('5 PUSH 3 MULT PRINT').eval
puts "---------------"
Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
puts "---------------"
Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
puts "---------------"
Minilang.new('5 PUSH POP POP PRINT').eval
puts "---------------"
Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
puts "---------------"
Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
puts "---------------"
Minilang.new('-3 PUSH 5 XSUB PRINT').eval
puts "---------------"
Minilang.new('-3 PUSH 5 SUB PRINT').eval
puts "---------------"
Minilang.new('6 PUSH').eval