#!/usr/bin/env ruby

# A script to startup the dependencies for an interactive session
# Note the files being referenced from project root, this is because this script should run in the context of the root dir in irb or pry
Dir["./config/config.rb"].each {|file| require file }
Dir["./lib/tempactions.rb"].each {|file| require file} #TODO eventually work this into the app structure itself then remove this line and the file

include Configuration::Datedata
include Configuration::Mockdata
include Configuration::Browserdriver




###########
## Setup ##  #TODO keep adding for full use, clean it up and sync with tests
###########
# pulls in application configurations
Dir["./config/config.rb"].each {|file| require file }
# pulls in dependent classes
Dir["./app/Elements/browser.rb", "./app/Elements/Onlineaha/user.rb", "./app/Pages/**.rb", "./app/Pages/Onlineaha/**/**.rb"].each { |file| require file }
include Configuration::Testrunner