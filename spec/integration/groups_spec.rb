require 'integration_spec_helper'
require 'spec_helper'

describe "Groups" do
  describe "join a new group" do
    it "should validate the request and redirect to the group path" do        
        user = Factory(:user)
        group = Factory(:group, :current_user_id => 1, :member_name => 'Nick')
        login_user(user)
        visit join_groups_path(:user_id => user.id)        
        fill_in 'group_token',    :with => group.group_token
        fill_in "member_name",    :with => user.name
        click_button
        response.should render_template('groups/show')
    end
  end
  
  describe "display the group members section" do
    before(:each) do
      @user = Factory(:user)
      @group = Factory(:group, :current_user_id => 1, :member_name => 'Nick')      
      login_user(@user)      
    end

    it "should not display group members section" do        
        visit group_path(@group)
        response.should contain('You are the only member in this group')
    end
      
    it "should display the group members section" do        
        @member = Factory(:member, :name => 'Adam', :group_id => @group.id)
        visit group_path(@group)
        response.should have_selector('.member_section')
    end
  end
  
end