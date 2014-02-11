class HeaderLogInFormPageElement

  ## A secondary mode of sign in from outside the HomePage/SignInPage scope; appears in headerbar
  ## Known on pages: .., ContactPage, ..

  private_class_method :new

  ################
  ## ATTRIBUTES ##
  ################

  def self.name
    "header log in form"
  end

  def self.email_input
    find('#login-email')
  end

  def self.password_input
    find('#login-password')
  end

  def self.submit_button
    find('input[type="submit"]')
  end

  ############################
  ## NAVIGATION ('command') ##
  ############################

  def self.fill_in_email(email)
    email_input.set(email)
  end

  def self.fill_in_password(password)
    password_input.set(password)
  end

  def self.submit_form
    submit_button.click
  end

  #**BEGIN INTENDED PUBLIC INTERFACE**#

  def self.fill_form( params = {} )
    fill_in_email( params[:email] )
    fill_in_password( params[:password] )
    submit_form
  end

  #**END INTENDED PUBLIC INTERFACE**#

  ###########################
  ## INFORMATION ('query') ##
  ###########################

  def self.is_present?
    has_css?('#header-login')
  end
end