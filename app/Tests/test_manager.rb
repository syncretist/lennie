## allow for running multiple files
## http://crashruby.com/2013/05/10/running-a-minitest-suite/
if __FILE__ == $0
  $LOAD_PATH.unshift('Tests')

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
    puts "Running all available tests...\n".blue.on_yellow
  else
    # run selected full categories
    category_selection.each do |c|
      Dir.glob("./app/Tests/Onlineaha/#{c}/**.rb") do |f|
        begin
          require f
        rescue LoadError
        end
      end
      puts " ==> running all #{c} tests\n".light_green
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
  end
end