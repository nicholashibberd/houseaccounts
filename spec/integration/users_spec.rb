require 'spec_helper'

describe "Users" do
  
  describe "signup" do
    
    describe  "failure" do
      it "should not make a new user" do
        visit register_url
        click_button
        response.should render_template('users/new')
        response.should have_selector("div#errorExplanation")
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
    
  end
  
end