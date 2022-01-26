class Person
  attr_writer :secret

  def share_secret
    puts secret
  end

  def compare_secret(other_person)
    secret == other_person.secret
  end

  protected

  attr_reader :secret
end

person1 = Person.new
person1.secret = 'Shh... this is a secret'
# puts person1.secret
# person1.share_secret
person2 = Person.new
person2.secret = 'Shh... this is a different secret'
puts person1.compare_secret(person2)
