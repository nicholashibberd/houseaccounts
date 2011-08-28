require 'integration_spec_helper'
require 'spec_helper'


describe "Members" do
  
  describe "show the last 10 members section" do
    before(:each) do
      @group = Factory(:group, :current_user_id => 1, :member_name => 'Nick')
      @member = Factory(:member, :name => 'Adam', :group_id => @group.id)
      @member2 = Factory(:member, :name => 'Dave', :group_id => @group.id)        
      login_user_blank
    end
    
    it "should display no payments section" do
      visit member_path(@member)
      response.should contain("Adam has not made any payments yet")
    end

    it "should display last 10 payments section" do
      payment = Factory(:payment, :amount => 999, :description => 'Test description', :member_id => @member.id, :liable_member_ids => [@member.id, @member2.id], :date => Date.today)
      visit member_path(@member)
      response.should contain("Last 10 payments")
    end
  end
  
end