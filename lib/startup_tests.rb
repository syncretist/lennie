#!/usr/bin/env ruby

# A script to startup the dependencies for test suite runs
# Note the files being referenced from project root, this is because this script should run in the context of the root dir
Dir["./config/config.rb"].each {|file| require file }
Dir["./lib/status_poster.rb"].each {|file| require file} #TODO eventually work this into the app structure itself then remove this line and the file

include Configuration::Datedata
include Configuration::Mockdata
include Configuration::Browserdriver
include Configuration::Database
include Configuration::Testcontext

include Configuration::Testrunner