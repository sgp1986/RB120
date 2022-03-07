=begin
+Inside a preschool there are children, teachers, class assistants, a principle, janitors, and cafeteria workers. 

+Both teachers and assistants can help a student with schoolwork and watch them on the playground. 

+A teacher teaches and an assistant helps kids with any bathroom emergencies. 

+Kids themselves can learn and play. 

+A teacher and principle can supervise a class. 

+Only the principle has the ability to expel a kid. 

+Janitors have the ability to clean. 

+Cafeteria workers have the ability to serve food. 

+Children, teachers, class assistants, principles, janitors and cafeteria workers all have the ability to eat lunch.
=end

module Eat
  def eat_lunch
  end
end

module Helpable
  def help_with_schoolwork
  end

  def help_with_bathroom_emergencies
  end

  def watch_playground
  end
end

module Supervisable
  def supervise_a_class
  end
end

class Child
  include Eat

  def learn
  end

  def play
  end
end

class Teacher
  include Eat, Helpable, Supervisable
end

class ClassAssistant
  include Eat, Helpable
end

class Principal
  include Eat, Supervisable
  
  def expel_student
  end
end

class Janitor
  include Eat

  def clean
  end
end

class CafeteriaWorker
  include Eat

  def serve_food
  end
end
