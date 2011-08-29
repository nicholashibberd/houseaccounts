#require File.dirname(__FILE__) + '/../spec_helper'
require 'spec_helper.rb'

describe MembersController do
  
  describe "allow permitted users access" do   
    before(:each) do
      @member = mock_model(Member)
      @group = mock_model(Group)
      Member.stub!(:find).and_return(@member)
      controller.stub!(:signed_in?).and_return(true)
      @member.stub_chain(:group, :users, :include?).and_return(true)
    end
    
    it "should allow access to the show page" do
      get 'show', :id => @member.id, :group_id => @group.id
      response.should be_success
    end

    it "should allow access to the edit page" do
      get 'edit', :id => @member.id, :group_id => @group.id
      response.should be_success
    end
  end
  
  describe "disallow non-permitted users access" do   
    before(:each) do
      @member = mock_model(Member)
      @group = mock_model(Group)
      Member.stub!(:find).and_return(@member)
      controller.stub!(:signed_in?).and_return(true)
      @member.stub_chain(:group, :users, :include?).and_return(false)
      @user = mock_model(User)
      controller.stub!(:current_user).and_return(@user)
    end
    
    it "should not allow access to the show page" do
      get 'show', :id => @member.id, :group_id => @group.id
      response.should redirect_to(user_path(@user))
    end

    it "should not allow access to the edit page" do
      get 'edit', :id => @member.id, :group_id => @group.id
      response.should redirect_to(user_path(@user))
    end
  end
  
  describe "creating a new member" do
    before(:each) do
      @group = mock_model(Group)
      @member = Factory(:member, :group_id => @group.id)
      @member2 = Factory(:member)
      Member.stub!(:find).and_return(@member2)
      Member.stub!(:new).and_return(@member)
      controller.stub!(:signed_in?).and_return(true)
    end
    
    it "should redirect to the new group when created" do
      @member.should_receive(:save).and_return(true)
      @member.stub!(:group).and_return(@group)
      post :create, :id => @member.id, :group_id => @group.id, :email => 'test@test.com'
      response.should redirect_to(member_path(@member))
    end
    
    it "should redirect to the user page if group fails to save" do
      @member.should_receive(:save).and_return(false)
      @user = mock_model(User)
      controller.stub!(:current_user).and_return(@user)
      post :create, :id => @member.id, :group_id => @group.id
      response.should redirect_to(user_path(@user))
    end
  end
  
  describe "deleting a member" do
    before(:each) do
      @group = mock_model(Group)
      @member = Factory(:member, :group_id => @group.id, :name => 'Member1')
      @member2 = Factory(:member, :group_id => @group.id, :name => 'Member2')
      @member.stub!(:group).and_return(@group)
      @group.stub!(:members).and_return([@member, @member2])
      Member.stub!(:find).and_return(@member)
      controller.stub!(:signed_in?).and_return(true)
    end
    
    it "should not delete if the member has an outstanding balance" do
      @member.stub!(:overall_balance).and_return(1000)
      delete :destroy, :id => @member.id
      flash[:error].should == "#{@member.name} still has an unsettled balance!"
    end

    it "should delete the member if their balance is settled" do
      @member.stub!(:overall_balance).and_return(0)
      delete :destroy, :id => @member.id
      response.should redirect_to group_path(@group)
    end
  end
  
  describe "send email to new user" do
    before(:each) do
      @group = mock_model(Group)
      Group.stub!(:find).and_return(@group)
      @user = Factory(:user)      
      @group.stub!(:get_member).and_return(@user)
      @member = Factory(:member, :group_id => @group.id, :name => 'Member1', :user_id => @user.id)
      @member2 = Factory(:member, :group_id => @group.id, :name => 'Member2')
      Member.stub!(:find).and_return(@member)
      controller.stub!(:signed_in?).and_return(true)
      controller.stub!(:current_user).and_return(@user)
    end
    
    it "should correctly send the email" do
      #post send_email_member_path(@member), :group_id => @group.id, :member_id => @member2.id, :email_address => 'nicholashibberd@hotmail.com'
      post :send_email, :id => @member.id, :group_id => @group.id, :email_address => 'nicholashibberd@hotmail.com'
    end
  end
  
end