=begin
NOTES

#TODO CREATE HELPER UTILS, like putting name of current test heirarchy, putting object_id to see if it is unique each time or same one, etc...
#TODO abstract user creation for often used users, like a factory (ex. sa, etc... )

 NOTE : Certain global suite variables are set in the config -- make sure these are set properly before running suite
  #TODO allow entry of these values pre suite run at the command line, ask and answer style
  # WEBSITE
 etc...

Should we break up into 'tests by action, tests by feature, tests by user, tests by page... etc...?' ::TITLE OF FILE CONCERN IN #### below::

=end


#####
##### Login
#####

###########
## Setup ##
###########

# pulls in application configurations
Dir["./config/config.rb"].each {|file| require file }

# pulls in dependent classes
Dir["./app/Elements/browser.rb", "./app/Elements/Onlineaha/aha_courses.rb", "./app/Elements/Onlineaha/user.rb", "./app/Pages/**.rb", "./app/Pages/Onlineaha/**/**.rb"].each { |file| require file }

# pulls in and loads dependent modules
Dir[""].each do |file|
  require file
  load file
end

###############
## Test Info ##
###############

# Inventory:
# Actions                     => Log in
# Elements | Users            => Scitent Admin
# Elements | Packages, etc... =>
# Pages                       => home page, admin dashboard page, sign in page, contact page (any other page to log in via headerbar log in)
# Page Elements               => headerbar login

###########
## Tests ##
###########

describe "Log in" do
  describe "for Scitent Admin" do

    let(:user) { User.new( :first_name => "Scitent", :last_name => "Admin", :email => AHA_USERS['scitent-admin']['email'], :password => AHA_USERS['scitent-admin']['password'] ) }
    # another permutation of 'scitent admin' could be non seeded user with SA permissions

    before do
      user.visit_website( :via_homepage )
    end

    after do
      #puts "Last user object id was: #{user.object_id}"
      user.log_out
    end

    describe "from homepage" do
      it "should resolve on admin dashboard page" do
        user.log_in
        #TODO have cross cutting module of tests for flash messaging, make sure it shows up as blue with proper text about successful signin
        current_url.must_equal AdminDashboardPage.url
      end
    end
    describe "from header log in" do
      it "should resolve on admin dashboard page" do
        user.navigate_to(ContactPage)
        user.log_in
        #TODO have cross cutting module of tests for flash messaging, make sure it shows up as blue with proper text about successful signin
        current_url.must_equal AdminDashboardPage.url
      end
    end
    describe "from sign in page" do
      it "should resolve on admin dashboard page" do
        user.navigate_to(SignInPage)
        user.log_in
        #TODO have cross cutting module of tests for flash messaging, make sure it shows up as blue with proper text about successful signin
        current_url.must_equal AdminDashboardPage.url
      end
    end
  end
end