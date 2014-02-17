class LogInFormPageElement

  private_class_method :new

  #################
  ## INFORMATION ##
  #################

  def self.name
    "log in form"
  end

  def self.description
    "Primay mode of sign in from the HomePage/SignInPage scope"
  end

  def self.known_pages
    [HomePage, SignInPage]
  end

  #####################
  ## DOM INFORMATION ##
  #####################

  def self.dom
    {
        :element_container    => '#login',
        :email_input          => '#user_email',
        :password_input       => '#user_password',
        :submit_button        => '#login .contents input[type="submit"]',
        :forgot_password_link => '#login .contents a:nth-child(3)',
        :help_link            => '#login .contents a:nth-child(4)',
        :sign_up_link         => '#login .contents a:nth-child(6)'
    }
  end

  ################
  ## ATTRIBUTES ##
  ################

  def self.target(element)
    find("#{element}")
    ## abstract this out to base element inheritence
    ## use method missing and metaprogramming (like attr accessor) to build methods for each dom input key name, use directly in navigation and query
    # SIDEEFFECT add log note of what is happening
    # SIDEEFFECT add screenshot option
    # SIDEEFFECT add and remove jquery border option
    # RETURN the capybara element
  end

  ###################################
  ## SIMPLE NAVIGATION ('command') ##
  ###################################

  def self.fill_in_email(email)
    target(dom[:email_input]).set(email)
  end

  def self.fill_in_password(password)
    target(dom[:password_input]).set(password)
  end

  def self.submit_form
    target(dom[:submit_button]).click
  end

  ######################################
  ## AGGREGATE NAVIGATION ('command') ##
  ######################################

  def self.fill_form( params = {} )
    fill_in_email( params[:email] )
    fill_in_password( params[:password] )
    submit_form
  end

  ###########################
  ## INFORMATION ('query') ##
  ###########################

  def self.is_present?
    has_css?(dom[:element_container])
  end

  private_class_method :target

end