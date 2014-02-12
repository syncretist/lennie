class TechsupportSearchNavPageElement

  private_class_method :new

  #################
  ## INFORMATION ##
  #################

  def self.name
    "techsupport search tabs"
  end

  def self.description
    "The main navigation to access different search forms via techsupport interface"
  end

  def self.known_pages
    [AdminTechsupportSearchPage]
  end

  ################
  ## ATTRIBUTES ##
  ################

  def self.nav_container
    find('#search-tabs')
  end

  def self.user_nav_item
    find('#user-tab')
  end

  def self.key_nav_item
    find('#key-tab')
  end

  def self.order_nav_item
    find('#order-tab')
  end

  def self.okm_order_nav_item
    find('#okmorder-tab')
  end

  ############################
  ## NAVIGATION ('command') ##
  ############################

  def self.click_user_nav
    user_nav_item.click
  end

  def self.click_key_nav
    key_nav_item.click
  end

  def self.click_order_nav
    order_nav_item.click
  end

  def self.click_okm_order_nav
    okm_order_nav_item.click
  end

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