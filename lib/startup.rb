#!/usr/bin/env ruby

# A script to startup the application and setup dependencies
# Note the files being referenced from project root, this is because this script should run in the context of the root dir in ruby execution, irb or pry
require './lib/project_baseline.rb'

FileList['./config/config.rb'].each {|file| safe_require file }

include Configuration::DateTimedata
include Configuration::Mockdata
include Configuration::Browserdriver
include Configuration::Testrunner if PROJECT_MODE == :test_suite

DisplayProjectContext.display

if PROJECT_MODE == :interactive

  #TODO keep adding for full use, clean it up and sync with specifc test setups

  # pulls in dependent classes
  Dir["./app/Elements/browser.rb", "./app/Elements/Onlineaha/aha_courses.rb", "./app/Elements/Onlineaha/user.rb", "./app/Pages/**.rb", "./app/Pages/Onlineaha/**/**.rb"].each { |file| safe_require file }

end
