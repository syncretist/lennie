class HomePage < AbstractPage

  ################
  ## ATTRIBUTES ##
  ################

  def self.route
    '/'
  end

  def self.name
    'home page'
  end

  def self.page_elements
    {LogInFormPageElement.name => LogInFormPageElement}
  end
end