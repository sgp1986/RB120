class Person
  attr_accessor :name, :first_name, :last_name

  def initialize(name)
    @first_name = name.split.first
    @last_name = name.split.size > 1 ? name.split.last : ''
    @name = last_name.empty? ? first_name : [first_name, last_name].join(' ')
  end

  def name=(name)
    names = name.split
    if names.size > 1
      self.first_name = names.first
      self.last_name = names.last
      @name = [first_name, last_name].join(' ')
    else
      self.first_name = names.first
      self.last_name = ''
      @name = first_name
    end
  end

  def last_name=(name)
    @last_name = name
    @name = [first_name, last_name].join(' ')
  end

  def ==(other)
    name == other.name
  end

  def to_s
    name
  end
end