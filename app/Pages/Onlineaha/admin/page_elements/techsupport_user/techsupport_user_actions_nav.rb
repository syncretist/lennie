class TechsupportUserActionsNavPageElement

  private_class_method :new

  #################
  ## INFORMATION ##
  #################

  def self.name
    "techsupport user actions nav"
  end

  def self.description
    "The main navigation to access different actions via techsupport user interface"
  end

  def self.known_pages
    [AdminTechsupportUserPage]
  end

  ################
  ## ATTRIBUTES ##
  ################

  def self.nav_container
    find('#page-div .pull-right')
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
    nav_container.visible?
  end
end