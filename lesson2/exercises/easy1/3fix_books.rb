# complete the program so it produces the expected output

class Book
  attr_reader :author, :title
  def initialize(author, title)
    @author = author
    @title = title
  end

  def to_s
    %("#{title}", by #{author})
  end
end

book = Book.new("Neil Stephenson", "Snow Crash")
puts %(The author of #{book.title} is #{book.author}.)
puts %(book = #{book}.)

# further exploration - 
  # attr_reader will create a getter method to allow you to read the instance variable
  # attr_writer will create a setter method to allow you to change the instance variable
  # attr_accessor will create a getter and setter method and allow you to do both
  # we did not need to change the author or title so we only needed a getter method
  # the shown methods would not hanve changed anything, we just used Ruby's shorthand version of those methods
  # creating those methods would give us additional options if we wanted when getting/setting the instance variable
  