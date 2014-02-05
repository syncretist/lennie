#LOAD IT ALL IN           =>
Dir["./config.rb"].each {|file| require file }
#GET INTO TEST SCOPE      =>
include Configuration::Temptest

#LOAD DEPENDENCIES
require_relative '../Elements/user'

class TestMeme < Minitest::Test
  def setup
    visit Configuration::Website::BASEURL
    @user = User.new
    @text = 'Key'
  end

  def test_fill_in_name
    fill_in('user_email',    :with => @user.first_name)
    fill_in('user_password', :with => @user.last_name)
  end

  def test_that_kitty_can_eat
    #desc("AOP outputs log of what is going on, provides breakpoint, takes screenshots?") | or metaprogramming to make every method with certain name have beginning and end methods automatically
    assert page.has_content? @text
  end
end