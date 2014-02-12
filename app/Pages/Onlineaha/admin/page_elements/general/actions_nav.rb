class ActionsNavPageElement

  private_class_method :new

  #################
  ## INFORMATION ##
  #################

  def self.name
    "actions nav"
  end

  def self.description
    "Icon links to create, read, update, and delete data from the interface, become users, etc..."
  end

  def self.known_pages
    [AdminTechsupportSearchPage, AdminDashboardPage]
  end

  ################
  ## ATTRIBUTES ##
  ################

  def self.nav_containers
    all('.actions-nav')
  end

  def self.edit_icon_links
    all('.do-edit')
  end

  def self.delete_icon_links
    all('.do-delete')
  end

  def self.become_links
    all('.do-become-user')
  end

  ############################
  ## NAVIGATION ('command') ##
  ############################

  #**BEGIN INTENDED PUBLIC INTERFACE**#

  def first_edit_icon_link
    edit_icon_links[0]
  end

  def first_delete_icon_link
    delete_icon_links[0]
  end

  def first_become_link
    become_links[0]
  end

  #**END INTENDED PUBLIC INTERFACE**#

  ###########################
  ## INFORMATION ('query') ##
  ###########################

  def self.is_present?
    has_css?('.actions_nav')
  end

  def self.edit_is_present?
    has_css?('.do-edit')
  end

  def self.delete_is_present?
    has_css?('.do-delete')
  end

  def self.become_is_present?
    has_css?('.do-become-user')
  end

end