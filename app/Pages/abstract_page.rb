class AbstractPage

  private_class_method :new # make sure and add this to each class, they should be singleton classes

  ################
  ## ATTRIBUTES ##
  ################

  def self.route( id=nil, query=nil, fragment=nil )
    # route to the specific page in the app context
    # if there is state specific info it is entered as parameter and handled by each page
    #   id              => specific element id
    #   query    (?...) => specific query string(s)
    #   fragment (#...) => specific url fragment(s)
    raise '::MUST OVERRIDE ABSTRACT PAGE CLASS FOR VALUE::'
  end

  def self.url
    SESSION_BASEURL + route
  end

  def self.name
    # plain text name of this page
    raise '::MUST OVERRIDE ABSTRACT PAGE CLASS FOR VALUE::'
  end

  def self.page_elements
    # hash with access to elements referenced for the page
    # { PageClass.name => PageClass }
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