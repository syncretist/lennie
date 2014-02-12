class User

  attr_reader :first_name, :last_name, :email, :password

  def initialize( params = {} )
    @first_name = params[:first_name] || Faker::Name.first_name
    @last_name  = params[:last_name]  || Faker::Name.last_name
    @email      = params[:email]      || ''
    @password   = params[:password]   || ''
  end


  def visit_website(via)
    # EX: 'user goes to site', can be many options depending on context, through homepage, through search engine, through direct url, etc...
    if via == :via_homepage
      HomePage.go
    end
  end

  def log_in
    url = current_url # cache capybara result (best practice)

    if url.include? SESSION_BASEURL + "/"
      if HomePage.is_current_page? || SignInPage.is_current_page?
        fill_in('user_email', :with => email)
        fill_in('user_password', :with => password)
        click_button('Sign In')
      elsif HeaderLogInFormPageElement.is_present?
        HeaderLogInFormPageElement.fill_form( :email => email, :password => password )
      else
        #TODO revamp this message to include all forms of login (homepage, signin page or headerbar login)
        puts "You are at #{current_url}, you should be at #{@home_url} to sign in!!! I am logging you out, please try again."
        logout
      end
    elsif url.include? SESSION_OKMURL + "/"

    elsif url.include? SESSION_MYONLINEURL + "/"

    else
      puts "This is not the right website"
    end
  end

  def log_in_via_become_functionality

  end

  def log_out
    #TODO right now this uses the url bar to logout directly, make it smarter and more able to logout with buttons as user does in different contexts
    # maybe do an element for logout and check if it exists and use it, else 'hard logout' by forcing the link
    visit(SESSION_BASEURL + "/users/sign_out")
  end

  def log_out_via_become_functionality
    #TODO right now this uses the url bar to logout directly, make it smarter and more able to logout with buttons as user does in different contexts
    # maybe do an element for logout and check if it exists and use it, else 'hard logout' by forcing the link
    visit(SESSION_BASEURL + "/users/sign_out")
    visit(SESSION_BASEURL + "/users/sign_out") # second time for become user, then admin
  end

  def navigate_to(page)
    #TODO right now this uses the url bar to navigate directly, make it smarter and more able to navigate links, buttons etc to traverse like REAL user, maybe pass in the specific capybara elements?
    page.go
  end

end