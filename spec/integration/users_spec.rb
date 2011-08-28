require 'integration_spec_helper'
require 'spec_helper'

describe "Users" do
  
  describe "signup" do
    
    describe  "failure" do
      it "should not make a new user" do
        visit register_url
        click_button
        response.should render_template('users/new')
        response.should have_selector("li.flash_item.email")
        response.should have_selector("li.flash_item.password")
        response.should have_selector("li.flash_item.name")
      end
      
      it "should not make a new user" do
        lambda do
          visit register_url
          click_button
        end.should_not change(User, :count)
      end
    end
    
    describe "success" do
      it "should make a new user" do
        lambda do
          visit register_url
          fill_in "Name",         :with => "New User"
          fill_in "Email",        :with => 'test@test.com'
          fill_in "Password",     :with => 'password'
          fill_in "Password Confirmation", :with => 'password'
          click_button
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end
    
    describe "display top nav" do
      it "should not display the top nav when the user is not logged in" do
        visit home_path
        response.should_not have_selector("#top_nav")
      end

      it "should display the top nav when the user is logged in" do
        login_user_blank
        visit home_path
        response.should have_selector("#top_nav")
      end
    end
    
    describe "user_group_summary" do
      it "should display no members statement" do
        user = Factory(:user)
        group = Factory(:group, :current_user_id => user.id, :member_name => 'Nick')
        login_user(user)
        visit user_path(user)
        response.should contain("No payments have been added for this group")
      end
    end
  end
    
end