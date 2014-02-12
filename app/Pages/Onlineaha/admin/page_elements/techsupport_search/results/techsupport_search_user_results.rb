class TechsupportSearchUserResultsPageElement

  private_class_method :new

  #################
  ## INFORMATION ##
  #################

  def self.name
    "techsupport search user results"
  end

  def self.description
    "The results of user search for 'Find User By...' via techsupport interface"
  end

  def self.known_pages
    [AdminTechsupportSearchPage, AdminDashboardPage]
  end

  ################
  ## ATTRIBUTES ##
  ################

  def self.nav_container
    find('#user-results')
  end

  ############################
  ## NAVIGATION ('command') ##
  ############################

  #**BEGIN INTENDED PUBLIC INTERFACE**#

  def self.select_id_link_for_first_result
    nav_container.find('tbody').all('tr')[0].all('td')[0].find('a').click
  end

  #**END INTENDED PUBLIC INTERFACE**#

  ###########################
  ## INFORMATION ('query') ##
  ###########################

  def self.is_present?
    nav_container.visible?
  end
end