###########
## Setup ##
###########

# pulls in application configurations
Dir["./config/config.rb"].each {|file| require file }

# pulls in dependent classes
Dir["./app/Elements/browser.rb", "./app/Elements/user.rb", "./app/Pages/**/**.rb"].each { |file| require file }

# pulls in and loads dependent modules
Dir[""].each do |file|
  require file
  load file
end

###########
## Tests ##
###########

#TODO CREATE HELPER UTILS, like putting name of current test heirarchy, putting object_id to see if it is unique each time or same one, etc...
#TODO abstract user creation for often used users, like a factory (ex. sa, etc... )

describe "Login" do
  describe "Scitent Admin" do

    let(:user) { User.new( :first_name => "Scitent", :last_name => "Admin", :email => SECURE_INFO[:sa_email], :password => SECURE_INFO[:sa_password] ) }

    describe "from homepage" do
      it "should end up on admin dashboard" do
        binding.pry
      end
    end
    describe "from headerbar" do
      it "should end up on admin dashboard" do

      end
    end
    describe "from sign in page" do
      it "should end up on admin dashboard" do

      end
    end
  end
end




=begin
          let(:t) { Tester.new(params[:home_url]) }

          describe "login from homepage" do
            #minitest_name_util
            binding.pry
            it "it should resolve at the admin dashboard" do
              #t.visit_home_url
              #t.login_type_selector(params)
            end
          end

          describe "login from headerbar" do
            #t.visit_home_url
          end

          describe "login from sign in page" do
            #t.visit_home_url
          end
        end
=end
