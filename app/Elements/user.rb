class User

  attr_reader :first_name, :last_name, :email, :password

  def initialize( params = {} )
    @first_name = params[:first_name] || Faker::Name.first_name
    @last_name  = params[:last_name]  || Faker::Name.last_name
    @email      = params[:email]      || ''
    @password   = params[:password]   || ''
  end
end