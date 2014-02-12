## allow for running multiple files
## http://crashruby.com/2013/05/10/running-a-minitest-suite/
if __FILE__ == $0
  $LOAD_PATH.unshift('Tests')
  Dir.glob('./app/Tests/**/**.rb') { |f| require f }
end