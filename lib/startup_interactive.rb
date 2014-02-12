#!/usr/bin/env ruby

# A script to startup the dependencies for an interactive session
# Note the files being referenced from project root, this is because this script should run in the context of the root dir in irb or pry
Dir["./config/config.rb"].each {|file| require file }
Dir["./app/tempactions.rb"].each {|file| require file} #TODO eventually work this into the app structure itself then remove this line

include Configuration::Datedata
include Configuration::Mockdata
include Configuration::Browserdriver