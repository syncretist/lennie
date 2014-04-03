module Configuration

  FileList['./config/database.rb'].each {|file| safe_require file }
  FileList['./config/project_context.rb'].each {|file| safe_require file}

  DB_CLIENT = DatabaseConnection.connect

  FileList['./config/project_files.rb'].each {|file| safe_require file}
  FileList['./lib/*'].exclude(/startup|project_baseline/).each {|file| safe_require file }
  Dir["./app/Tests/Datatesting/**/**/**.rb"].each {|file| safe_require file} #TODO eventually work this into the app structure itself then remove this line and the file



  module Mockdata
    safe_require 'faker'
    I18n.enforce_available_locales = false # takes care of faker warning message
  end
  module DateTimedata
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
    safe_require 'colorize'

    # https://github.com/visionmedia/terminal-table
    safe_require 'terminal-table'
  end
  module Debugging
    safe_require 'pry-debugger' # allows use of binding.pry throughout without explicit reference
  end

  module Browserdriver
    safe_require 'capybara'
    #safe_require 'capybara/dsl' # may not be explicitly needed if it already allows me to use commands on main object via include below 'Capybara::DSL'

    Capybara.run_server = false
    Capybara.current_driver = :selenium
    Capybara.app_host = "http://scitent.us"

    # Setting a longer timeout: http://stackoverflow.com/a/10020243
    safe_require 'net/http'

    http = Net::HTTP.new(@host, @port)
    http.read_timeout = 900

    include Capybara::DSL #allows for capybara browser driver method calls without prefix
  end
  module Benchmarking
    safe_require 'tach' # https://github.com/geemus/tach : allows for timing task runs
  end
  module Testrunner
    gem 'minitest' # to remove warning and use gem instead of built-in

    # http://www.rubyinside.com/a-minitestspec-tutorial-elegant-spec-style-testing-that-comes-with-ruby-5354.html
    # https://github.com/seattlerb/minitest
    # http://bfts.rubyforge.org/minitest/MiniTest/Spec.html
    # http://mattsears.com/articles/2011/12/10/minitest-quick-reference
    safe_require 'minitest/autorun'
    safe_require 'minitest/focus'
  end

end

