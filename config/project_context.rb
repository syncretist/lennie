module ProjectContext

  # 1. production or test mode when init, use different base urls etc...
  # 2. template file path/location to load them from

  ##########################################
  ## SET global values for test suite run ##
  ##########################################

  ## Mode
  #######

  #TODO find a way to dynamically choose this based on what is available in the project context file and what the user selects at runtime
  # integrate into lennie shell script for lennie-i and lennie-t

  PROJECT_MODE = :interactive # [:interactive, :test_suite, etc...]

  ## Website
  ##########

  WEBSITE_CONFIG = {
    'Session Protocol'     => SESSION_PROTOCOL = 'http://',                          # ['http://', 'https://']
    'Session Base URL'     => SESSION_BASEURL  = SESSION_PROTOCOL + 'f.scitent.us',  # ['f.scitent.us', 'beta.onlineaha.org']
    'Session OKM URL'      => SESSION_OKMURL   = '',
    'Session Myonline URL' => SESSION_MYONLINEURL = '',
  }

  ## External Services
  ####################

  POST_URIS = {
    ## choose one ##
    'the-migrator' => 'http://the-migrator.phx.scitent.com/utilities/test_results'
    #'the-migrator' => 'http://127.0.0.1:9292/utilities/test_results'
  }

  ## Database
  ###########

  #TODO find a way to dynamically choose this based on what is available in the database_secret file and what the user selects at runtime

  SESSION_DATABASE = Database::DATABASE_INFORMATION['aha-clone'] # ['aha-production', 'aha-staging', 'aha-local', etc...]

  ## Misc
  #######

end

include ProjectContext

class DisplayProjectContext

  def self.introduction
    logging_puts "For this session, all tests will be run in the following context:"
  end

  def self.website_config
    WEBSITE_CONFIG.each { |option, value| logging_puts "#{option}".magenta + ": #{value}"  }
  end

  def self.postable_uris
    logging_puts "Postable URIS: "
    POST_URIS.each { |option, value| logging_puts "#{option}".magenta + ": #{value}"  }
  end

  def self.database
    logging_puts "Database".magenta + ": Using #{SESSION_DATABASE['title']}, named '#{SESSION_DATABASE['database']}'. Access via #{SESSION_DATABASE['host']}"
  end

  #TODO add anything else that seems relevant

  def self.outro
    logging_puts "NOTE:".yellow + " to make changes to this context, see" + " ProjectContext".bold + " @ ./config/project_context.rb "
  end

  def self.display
    introduction
    website_config
    logging_puts ""
    postable_uris
    logging_puts ""
    database
    logging_puts ""
    outro
    logging_puts ""
  end

end