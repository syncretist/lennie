## allow for running multiple files
## http://crashruby.com/2013/05/10/running-a-minitest-suite/
if __FILE__ == $0
  $LOAD_PATH.unshift('Tests')

  ############################################################
  ## Display test context set in Configuration::Testcontext ##
  ############################################################

  puts "For this session, all tests will be run in the following context:"

  WEBSITE_CONFIG.each { |option, value| puts "#{option}".magenta + ": #{value}"  }

  puts ""

  puts "Database".magenta + ": Using #{SESSION_DATABASE[:title]}, named '#{SESSION_DATABASE[:database]}'. Access via #{SESSION_DATABASE[:host]}"

  puts ""

  puts "NOTE:".yellow + " to make changes to this context, see" + " Configuration::Testcontext".bold + " @ ./config/config.rb "
  puts ""

  #TODO add anything else that seems relevant

  ######################################################
  ## Choose test categories and specific tests to run ##
  ######################################################

  category_listing = Dir.entries('./app/Tests/Onlineaha').select {|entry| File.directory? File.join('./app/Tests/Onlineaha',entry) and !(entry =='.' || entry == '..') }
  test_listing     = Dir.glob('./app/Tests/Onlineaha/**/**.rb')

  puts "\nTest Categories:"
  puts "----------------\n"

  category_listing.each { |category| puts category }

  puts "\nList each category you would like run (seperate with " + "spaces".bold + ", leave blank if you want to run single tests or everything): "
  category_selection = gets.chomp.split

  puts "\nTests:"
  puts "------\n"

  test_listing.each { |test| puts test }

  puts "\nList each test you would like run (seperate with " + "spaces".bold + ", leave blank if you want to run only chosen categories or everything): "
  test_selection = gets.chomp.split

  puts "\n"
  if category_selection.empty? && test_selection.empty?
    # run all tests
    Dir.glob('./app/Tests/**/**.rb') { |f| require f }
    puts "Running all available tests...".blue.on_yellow
    puts ""
  else
    # run selected full categories
    category_selection.each do |c|
      Dir.glob("./app/Tests/Onlineaha/#{c}/**.rb") do |f|
        begin
          require f
        rescue LoadError
        end
      end
      puts " ==> running all #{c} tests".light_green
      puts ""
      #TODO add catch for putting in category names that dont work, right now they will pass this success message
      #TODO list all of the failed requireds if not all make it, and say (in yellow text) running 'most of the tests from #{c}', except for ...
    end
    # run selected tests
    test_selection.each do |f|
      begin
        require f
        puts " => going to run #{f}".green
      rescue LoadError
        puts " => cannot run #{f}".red
      end
    end
    puts ""
  end
end