#LOAD IT ALL IN           =>
Dir["./config.rb"].each {|file| require file }

# could this be a simple struct instead?

class User

  attr_reader :first_name, :last_name

  def initialize
    @first_name = Faker::Name.first_name
    @last_name  = Faker::Name.last_name

  end
end