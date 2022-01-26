# take the incomplete class and complete it so the test cases shown work as intended. add any methods or instance variables you need, but do not make the implementation details public. assume the input will always fit in your window
# further - add option to specify a fixed banner width and center message in the banner

class Banner
  attr_reader :message, :banner_width
  def initialize(message, banner_width=message.length + 2)
    @message = message
    @banner_width = banner_width % 2 == 0 ? banner_width : banner_width - 1
    @message_left_space = ' ' * ((banner_width - message.length) / 2)
    @message_right_space = message.length % 2 == 0 ? @message_left_space : ' ' * (((banner_width - message.length) / 2) + 1)
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private
  
  def horizontal_rule
    "+-#{'-' * @banner_width}-+"
  end

  def empty_line
    "| #{' ' * @banner_width} |"
  end

  def message_line
    "| #{@message_left_space}#{@message}#{@message_right_space} |"
  end

end

banner = Banner.new('To boldly go where no one has gone before.', 80)
puts "message length " + banner.message.length.to_s
puts "banner length " + banner.banner_width.to_s
puts banner
# +--------------------------------------------+
# |                                            |
# | To boldly go where no one has gone before. |
# |                                            |
# +--------------------------------------------+

banner = Banner.new("This is an odd length test banner", 70)
puts "message length " + banner.message.length.to_s
puts "banner length " + banner.banner_width.to_s
puts banner

banner = Banner.new("This is an even length test banner")
puts "message length " + banner.message.length.to_s
puts "banner length " + banner.banner_width.to_s
puts banner

banner = Banner.new('', 45)
puts banner
# +--+
# |  |
# |  |
# |  |
# +--+