#!/usr/bin/env ruby

# A script to startup the dependencies for test suite runs
# Note the files being referenced from project root, this is because this script should run in the context of the root dir
Dir["./config/config.rb"].each {|file| require file }

include Configuration::Website
include Configuration::Datedata
include Configuration::Mockdata
include Configuration::Temptest