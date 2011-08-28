#require File.dirname(__FILE__) + '/../spec_helper'
require 'spec_helper.rb'

describe GroupsController do
  
  describe "allow permitted users access" do   
    before(:each) do
      @group = mock_model(Group)
      Group.stub!(:find).and_return(@group)
      controller.stub!(:signed_in?).and_return(true)
      @group.stub_chain(:users, :include?).and_return(true)
    end
    
    it "should allow access to the show page" do
      get 'show', :id => @group.id
      response.should be_success
    end

    it "should allow access to the edit page" do
      get 'edit', :id => @group.id
      response.should be_success
    end
    
    it "should allow access to the join page" do
      user = Factory(:user)
      User.should_receive(:find).and_return(user)
      get 'join'
      response.should be_success
    end

    it "should allow access to the add page" do
      user = Factory(:user)
      User.should_receive(:find).and_return(user)
      get 'add'
      response.should be_success
    end
  end

  describe "disallow non-permitted users access" do   
    before(:each) do
      @group = mock_model(Group)
      Group.stub!(:find).and_return(@group)
      controller.stub!(:signed_in?).and_return(true)
      @group.stub_chain(:users, :include?).and_return(false)
      @user = mock_model(User)
      controller.stub!(:current_user).and_return(@user)
    end
    
    it "should not allow access to the show page" do
      get 'show', :id => @group.id
      response.should redirect_to(user_path(@user))
    end

    it "should not allow access to the edit page" do
      get 'edit', :id => @group.id
      response.should redirect_to(user_path(@user))
    end
  end
  
  describe "adding a new group" do
    before(:each) do
      @attr = { :current_user_id => 1, :member_name => "Nick" } 
      @group = Factory(:group, @attr)
      Group.stub!(:new).and_return(@group)
      controller.stub!(:signed_in?).and_return(true)
    end
    
    it "should redirect to the new group when created" do
      @group.should_receive(:save).and_return(true)
      post :add_new_group, :group => @attr
      response.should redirect_to(group_path(@group))
    end
    
    it "should redirect to the user page if group fails to save" do
      @group.should_receive(:save).and_return(false)
      @user = mock_model(User)
      controller.stub!(:current_user).and_return(@user)
      post :add_new_group, :group => @attr
      response.should redirect_to(user_path(@user))
    end
  end
  
end