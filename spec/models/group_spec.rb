# -*- coding: utf-8 -*-
require 'spec_helper'

describe Group do
  
  describe 'group should save with correct validations' do 
    it "group should not save without a name" do
      group = Group.new(:member_name => 'Nick', :current_user_id => 1)
      group.save
      group.errors.should include :name
    end

    it "group should not save without a current user id" do
      group = Group.new(:name => 'Test Group', :member_name => 'Nick')
      group.save
      group.errors.should include :current_user_id
    end

    it "group should not save without a member name" do
      group = Group.new(:name => 'Test Group', :current_user_id => 1)
      group.save
      group.errors.should include :member_name
    end

    it "group has one member on create" do
      user = Factory(:user)
      group = Group.create(:name => 'Test Group', :current_user_id => user.id, :member_name => 'Nick')
      group.members.size.should eql(1)
    end

    it "group is added to the current users groups" do
      user = Factory(:user)
      group = Group.create(:name => 'Test Group', :current_user_id => user.id, :member_name => 'Nick')
      user.groups.should include group
    end

    it "member is added to the current users members" do
      user = Factory(:user)
      group = Group.create(:name => 'Test Group', :current_user_id => user.id, :member_name => 'Nick')
      user.members.should include group.members.first
    end
  end
  
  describe 'get member' do
    it "should return the relevant member for the user" do
      @user = Factory(:user, :email => 'test@test.com')
      @user2 = Factory(:user, :email => 'test2@test.com')
      @group = Factory(:group, :current_user_id => @user.id, :member_name => 'Nick')
      @member = Factory(:member, :group_id => @group.id, :name => 'Adam', :user_id => @user2.id)
      @group.get_member(@user2).should eql(@member)
    end
  end
  
end