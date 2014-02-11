module Configuration
  module Project
    # 1. production or test mode when init, use different base urls etc...
    # 2. template file path/location to load them from

    # Incorporate secure info not checked into git or shared without permission
    if File.exist? "./config/secure_info.rb"
      require "./config/secure_info"
    else
      puts "NOTE: To properly run this suite:"
      puts "  1. you must have a local file titled 'secure_info.rb' in the config directory"
      puts "  2. it must have a module with a hash global 'SECURE_INFO' and values necessary"
      puts "  3. you must include the module at the bottom of the same file"
    end
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
  end
  module Mockdata
    require 'faker'
    I18n.enforce_available_locales = false # takes care of faker warning message
  end
  module Datedata
    def now
      Time.now
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
    require 'pry' # allows use of binding.pry throughout without explicit reference
  end
  module Benchmarking
    require 'tach' # https://github.com/geemus/tach : allows for timing task runs
  end
  module Temptest
    gem 'minitest' # to remove warning and use gem instead of built-in

    # http://www.rubyinside.com/a-minitestspec-tutorial-elegant-spec-style-testing-that-comes-with-ruby-5354.html
    # https://github.com/seattlerb/minitest
    # http://bfts.rubyforge.org/minitest/MiniTest/Spec.html
    # http://mattsears.com/articles/2011/12/10/minitest-quick-reference
    require 'minitest/autorun' #TODO uncomment when i start writing actual specs and not just browser 'puts' tests

    include Capybara::DSL #allows for capybara browser driver method calls without prefix (for use in 'interactive mode')

    ## SET global values for test suite run

    # Website
    SESSION_PROTOCOL = 'http://'                          # ['http://', 'https://']
    SESSION_BASEURL  = SESSION_PROTOCOL + 'f.scitent.us'  # ['f.scitent.us', 'beta.onlineaha.org']
    SESSION_OKMURL   = ''
    SESSION_MYONLINEURL = ''

    # Misc

  end
end