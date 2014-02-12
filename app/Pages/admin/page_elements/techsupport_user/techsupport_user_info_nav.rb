class TechsupportUserInfoNavPageElement

  private_class_method :new

  #################
  ## INFORMATION ##
  #################

  def self.name
    "techsupport user info nav"
  end

  def self.description
    "The main navigation to access different information via techsupport user interface"
  end

  def self.known_pages
    [AdminTechsupportUserPage]
  end

  ################
  ## ATTRIBUTES ##
  ################

  def self.nav_container
    find('ul.nav-tabs')
  end

  ############################
  ## NAVIGATION ('command') ##
  ############################

  #**BEGIN INTENDED PUBLIC INTERFACE**#


  #**END INTENDED PUBLIC INTERFACE**#

  ###########################
  ## INFORMATION ('query') ##
  ###########################

  def self.is_present?
    # apply this catch to all of these -- try to abstract out into single method for all so its cleaner?
    begin
      nav_container.visible?
    rescue
      false
    end
  end
end