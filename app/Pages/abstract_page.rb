class AbstractPage

  private_class_method :new

  ################
  ## ATTRIBUTES ##
  ################

  def self.route( id=nil )
    raise '::MUST OVERRIDE ABSTRACT PAGE CLASS FOR VALUE::'
  end

  def self.url
    SESSION_BASEURL + route
  end

  def self.name
    raise '::MUST OVERRIDE ABSTRACT PAGE CLASS FOR VALUE::'
  end

  def self.page_elements
    raise '::MUST OVERRIDE ABSTRACT PAGE CLASS FOR VALUE::'
  end

  ############################
  ## NAVIGATION ('command') ##
  ############################

  def self.go
    visit(url)
  end

  ###########################
  ## INFORMATION ('query') ##
  ###########################

  def self.is_current_page?
    current_url == url
  end

  def self.html_title

  end

end