#!/usr/bin/env ruby

# A script to startup the dependencies for an interactive session
# Note the files being referenced from project root, this is because this script should run in the context of the root dir in irb or pry
Dir["./config/config.rb", "./app/tempactions.rb"].each {|file| require file }

include Configuration::Datedata
include Configuration::Mockdata
include Configuration::Temptest
