#!/usr/bin/env ruby

# A script to startup the dependencies for an interactive session
# Note the files being referenced from project root, this is because this script should run in the context of the root dir in irb or pry
Dir["./config/config.rb"].each {|file| require file }
Dir["./app/Tests/data_testing.rb"].each {|file| require file} #TODO eventually work this into the app structure itself then remove this line and the file

include Configuration::Datedata
include Configuration::Mockdata
include Configuration::Browserdriver
include Configuration::Database
include Configuration::Testcontext

############################################################
## Display test context set in Configuration::Testcontext ##  #TODO this is copied from test manager, dry it up and run in both contexts
############################################################

puts "For this session, all tests will be run in the following context:"

WEBSITE_CONFIG.each { |option, value| puts "#{option}".magenta + ": #{value}"  }

puts ""

puts "Database".magenta + ": Using #{SESSION_DATABASE[:title]}, named '#{SESSION_DATABASE[:database]}'. Access via #{SESSION_DATABASE[:host]}"

puts ""

puts "NOTE:".yellow + " to make changes to this context, see" + " Configuration::Testcontext".bold + " @ ./config/config.rb "
puts ""

#TODO add anything else that seems relevant


###########
## Setup ##  #TODO keep adding for full use, clean it up and sync with specifc test setups
###########
# pulls in application configurations
Dir["./config/config.rb"].each {|file| require file }
# pulls in dependent classes
Dir["./app/Elements/browser.rb", "./app/Elements/Onlineaha/user.rb", "./app/Pages/**.rb", "./app/Pages/Onlineaha/**/**.rb"].each { |file| require file }

