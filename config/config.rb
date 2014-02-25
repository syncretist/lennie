module Configuration

  PROJECT_MAINTAINER_EMAIL = 'eglassman@scitent.com'

  module Mockdata
    require 'faker'
    I18n.enforce_available_locales = false # takes care of faker warning message
  end
  module Datedata
    #TODO add in timecop to easily manipulate and play with times and dates

    def now
      Time.now
    end

    def database_datetime_now
      # use to create current timestamps for 'created_at'/'updated_at' style db entries
      Time.now.strftime('%Y-%m-%d %H:%M:%S')
    end
  end
  module TerminalDesign
    # http://stackoverflow.com/questions/1489183/colorized-ruby-output
    # http://stackoverflow.com/questions/1108767/terminal-color-in-ruby
    # http://colorize.rubyforge.org/files/README_txt.html
    require 'colorize'

    # https://github.com/visionmedia/terminal-table
    require 'terminal-table'
  end
  module Debugging
    require 'pry-debugger' # allows use of binding.pry throughout without explicit reference
  end
  module Project
    # 1. production or test mode when init, use different base urls etc...
    # 2. template file path/location to load them from

    @element_configuration_manager_file = "./app/Elements/element_configuration_manager.rb"

    ## Dynamically load element data

    if File.exist? @element_configuration_manager_file
      require @element_configuration_manager_file
    else
      puts "NOTE:".yellow + " To properly run this suite:"
      puts " * You must have access to the private yml files containing sensitive data @ ./app/Elements/<project>/element_configuration/**"
      puts ""
      puts "Send an email to "+ "#{PROJECT_MAINTAINER_EMAIL}".bold + " with any questions."
      puts ""
    end

    ## Dynamically load page relationship data

    require "./app/Pages/page_configuration_manager.rb"
  end
  module Database

    @database_configuration_file = "./config/database.rb"

    if File.exist? @database_configuration_file
      require @database_configuration_file
    else
      puts "NOTE:".yellow + " To properly run this suite:"
      puts " * You must have the proper database configuration file @ ./config/database.rb"
      puts ""
      puts "Send an email to " + "#{PROJECT_MAINTAINER_EMAIL}".bold + " with any questions."
      puts ""
    end

    require 'mysql2'
  end
  module Browserdriver
    require 'capybara'
    #require 'capybara/dsl' # may not be explicitly needed if it already allows me to use commands on main object via include below 'Capybara::DSL'

    Capybara.run_server = false
    Capybara.current_driver = :selenium
    Capybara.app_host = "http://scitent.us"

    # Setting a longer timeout: http://stackoverflow.com/a/10020243
    require 'net/http'

    http = Net::HTTP.new(@host, @port)
    http.read_timeout = 700

    include Capybara::DSL #allows for capybara browser driver method calls without prefix
  end
  module Benchmarking
    require 'tach' # https://github.com/geemus/tach : allows for timing task runs
  end
  module Testrunner
    gem 'minitest' # to remove warning and use gem instead of built-in

    # http://www.rubyinside.com/a-minitestspec-tutorial-elegant-spec-style-testing-that-comes-with-ruby-5354.html
    # https://github.com/seattlerb/minitest
    # http://bfts.rubyforge.org/minitest/MiniTest/Spec.html
    # http://mattsears.com/articles/2011/12/10/minitest-quick-reference
    require 'minitest/autorun'
    require 'minitest/focus'
  end
  module Testcontext

    ##########################################
    ## SET global values for test suite run ##
    ##########################################

    ## Website
    ##########

    WEBSITE_CONFIG = {
      'Session Protocol'     => SESSION_PROTOCOL = 'http://',                          # ['http://', 'https://']
      'Session Base URL'     => SESSION_BASEURL  = SESSION_PROTOCOL + 'beta.onlineaha.org',  # ['f.scitent.us', 'beta.onlineaha.org']
      'Session OKM URL'      => SESSION_OKMURL   = '',
      'Session Myonline URL' => SESSION_MYONLINEURL = '',
    }

    ## External Services
    ####################

    POST_URIS = {
      ## choose one ##
      #'the-migrator' => 'http://scideainternal.scitent.com:9292/utilities/test_results'
      'the-migrator' => 'http://127.0.0.1:9292/utilities/test_results'
    }

    ## Database (uncomment the desired database for use)
    ###########

    #TODO figure out way to allow for non db use during sessions, and way to connect to local db(s)

    # http://stackoverflow.com/questions/8336090/cant-connect-ruby-on-rails-to-remote-mysql-database
    # http://stackoverflow.com/questions/4103809/how-to-create-a-ssh-tunnel-in-ruby-and-then-connect-to-mysql-server-on-the-remot
    require 'net/ssh/gateway'

    ## choose one ##
    SESSION_DATABASE = AHA_PRODUCTION
    #SESSION_DATABASE = AHA_CLONE
    #SESSION_DATABASE = AHA_STAGING
    #SESSION_DATABASE = AHA_LOCAL
    #SESSION_DATABASE = etc...

    begin
      puts ""
      puts "Connecting to the session database, please be patient..."
      puts ""

      gateway = Net::SSH::Gateway.new( SESSION_DATABASE[:host], SESSION_DATABASE[:username] )
      local_host  = '127.0.0.1'
      tunnel_port = gateway.open(local_host, 3306)

      DB_CLIENT = Mysql2::Client.new(
        :connect_timeout => 30, #seconds
        :encoding => SESSION_DATABASE[:encoding],
        :reconnect => SESSION_DATABASE[:reconnect],
        :database => SESSION_DATABASE[:database],
        :username => SESSION_DATABASE[:username],
        :password => SESSION_DATABASE[:password],
        :host => local_host, # port forward to remote db through net/ssh/gateway
        :port => tunnel_port
      )
      puts "... database connected!"
      puts ""
    rescue Mysql2::Error
      puts "The database was not configured properly, please check all configurations to repair...".red.bold
      puts ""
    end

    ## Misc
    #######

  end
end