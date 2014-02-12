class TechsupportSearchUserFormPageElement

  private_class_method :new

  #################
  ## INFORMATION ##
  #################

  def self.name
    "techsupport search user form"
  end

  def self.description
    "The user search options for 'Find User By...' via techsupport interface"
  end

  def self.known_pages
    [AdminTechsupportSearchPage, AdminDashboardPage]
  end

  ################
  ## ATTRIBUTES ##
  ################

  def self.nav_container
    find('#user-search')
  end

  def self.first_name_input
    find('#first_name')
  end

  def self.last_name_input
    find('#last_name')
  end

  def self.email_address_input
    find('#email')
  end

  def self.search_first_characters_checkbox
    find('#limit_to_first')
  end

  def self.find_users_button
    find_button('Find Users')
  end

  def self.reset_link
    find_link('Reset')
  end

  ############################
  ## NAVIGATION ('command') ##
  ############################

  def self.fill_in_first_name(first_name)
    first_name_input.set(first_name)
  end

  def self.fill_in_last_name(last_name)
    last_name_input.set(last_name)
  end

  def self.fill_in_email_address(email)
    email_address_input.set(email)
  end

  def self.toggle_search_first_characters_checkbox(value)
    search_first_characters_checkbox.set(value) # if true checked, if false unchecked
  end

  def self.submit_form
    find_users_button.click
  end

  def self.reset_form
    reset_link.click
  end

  #**BEGIN INTENDED PUBLIC INTERFACE**#

  def self.fill_form( params = {} )
    fill_in_first_name( params[:first_name] )
    fill_in_last_name( params[:last_name] )
    fill_in_email_address( params[:email_address] )
    toggle_search_first_characters_checkbox( params[:search_first_value] )
    submit_form
    # fill_form( :first_name => '', :last_name => '', :email_address => '', :search_first_value => true )
  end

  #**END INTENDED PUBLIC INTERFACE**#

  ###########################
  ## INFORMATION ('query') ##
  ###########################

  def self.is_present?
    nav_container.visible?
  end
end