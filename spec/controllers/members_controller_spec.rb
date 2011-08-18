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
      Member.stub!(:new).and_return(@member)
      controller.stub!(:signed_in?).and_return(true)
    end
    
    it "should redirect to the new group when created" do
      @member.should_receive(:save).and_return(true)
      @member.stub!(:group).and_return(@group)
      post :create, :id => @member.id, :group_id => @group.id
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
  
  

end