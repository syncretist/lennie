#####
##### ::TITLE OF FILE CONCERN HERE::
#####

###########
## Setup ##
###########

# pulls in application configurations
Dir["./config/config.rb"].each {|file| require file }

# pulls in dependent classes
Dir["./app/Elements/browser.rb", "./app/Elements/Onlineaha/user.rb", "./app/Pages/**.rb", "./app/Pages/Onlineaha/**/**.rb"].each { |file| require file }

# pulls in and loads dependent modules
Dir[""].each do |file|
  require file
  load file
end

###########
## Tests ##
###########

# Inventory:
# Actions                     =>
# Elements | Users            =>
# Elements | Packages, etc... =>
# Pages                       =>
# Page Elements               =>

describe "Admin User Management" do
  describe "for Scitent Admin" do

    let(:user) { User.new( :first_name => "Scitent", :last_name => "Admin", :email => AHA_USERS['scitent-admin']['email'], :password => AHA_USERS['scitent-admin']['password'] ) }

    before do
      user.visit_website( :via_homepage )
      user.log_in
      user.navigate_to(AdminDashboardPage)
      user.navigate_to(AdminUserManagementPage)
    end

    after do
      user.log_out
    end

    describe "from the main admin user management page" do
      it "should appear similar to the techsupport search interface" do
        assert TechsupportSearchUserFormPageElement.is_present?
      end

      it "should show search user form only" do
        refute TechsupportSearchNavPageElement.is_present?
      end
    end

    describe "from the search functionality on the main admin user management page" do
      it "should allow the same search options as Techsupport" do
        assert TechsupportSearchUserFormPageElement.first_name_input
        assert TechsupportSearchUserFormPageElement.last_name_input
        assert TechsupportSearchUserFormPageElement.email_address_input
        assert TechsupportSearchUserFormPageElement.search_first_characters_checkbox
      end

      it "should allow the same results table as Techsupport" do
        assert TechsupportSearchUserResultsPageElement.is_present?
      end
    end

    describe "from the user results of the search functionality on the main admin user management page" do
      it "should provide edit icon" do
        TechsupportSearchUserFormPageElement.fill_form( :first_name => 'Eric', :last_name => '', :email_address => '', :search_first_value => true )
        # elsewhere test a 0 results case, or a MANY results case for load
        assert ActionsNavPageElement.edit_is_present?
      end

      it "should provide delete icon" do
        TechsupportSearchUserFormPageElement.fill_form( :first_name => 'Eric', :last_name => '', :email_address => '', :search_first_value => true )
        assert ActionsNavPageElement.delete_is_present?
      end

      it "should not provide the become functionality" do
        TechsupportSearchUserFormPageElement.fill_form( :first_name => 'Eric', :last_name => '', :email_address => '', :search_first_value => true )
        refute ActionsNavPageElement.become_is_present?
      end
    end

    describe "from clicking on user id from the user results of the search functionality on the main admin user management page" do
      it "should open a new window" do
        TechsupportSearchUserFormPageElement.fill_form( :first_name => 'Eric', :last_name => '', :email_address => '', :search_first_value => true )
        TechsupportSearchUserResultsPageElement.select_id_link_for_first_result

        #TODO use procs/blocks/lambdas to allow this all to be moved to browser, with chunk of code executed in the middle of it
        parent = Browser.detect_current_window
        popup  = Browser.detect_popup_window
        Browser.switch_to_window(popup)
        # do work in popup
        Browser.number_of_open_windows.must_equal 2
        # end work in popup
        Browser.switch_to_window(popup)
        Browser.close_window
        Browser.switch_to_window(parent)

      end

      it "should appear similar to the same interface for Techsupport" do
        TechsupportSearchUserFormPageElement.fill_form( :first_name => 'Eric', :last_name => '', :email_address => '', :search_first_value => true )
        TechsupportSearchUserResultsPageElement.select_id_link_for_first_result

        #TODO use procs/blocks/lambdas to allow this all to be moved to browser, with chunk of code executed in the middle of it
        parent = Browser.detect_current_window
        popup  = Browser.detect_popup_window
        Browser.switch_to_window(popup)
        # do work in popup
        assert TechsupportUserActionsNavPageElement.is_present?
        assert TechsupportUserInfoNavPageElement.is_present?
        # end work in popup
        Browser.switch_to_window(popup)
        Browser.close_window
        Browser.switch_to_window(parent)
      end
    end
  end
end
