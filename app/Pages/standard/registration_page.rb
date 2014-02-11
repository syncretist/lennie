class RegistrationPage < AbstractPage

  ################
  ## ATTRIBUTES ##
  ################

  def self.route
    '/users/sign_up'
  end

  def self.name
    'registration page'
  end
end