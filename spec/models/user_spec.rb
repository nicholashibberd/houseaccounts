# -*- coding: utf-8 -*-
require 'spec_helper'

describe User do
  
  describe 'user should save with correct validations' do 
    it "should not save without a password" do
      user = User.new(:email => 'test@test.com', :password => 'password', :password_confirmation => 'password')
      user.save
      user.errors.should include :name
    end
    
    it "user should not save without a password" do
      user = User.new(:name => 'Nick', :email => 'test@test.com')
      user.save
      user.errors.should include :password
    end

    it "user should not save without a valid password" do
      user = User.new(:name => 'Nick', :email => 'test@test.com', :password => 'pass', :password_confirmation => 'pass')
      user.save
      user.errors.should include :password
    end

    it "user should not save if the passwords don't match" do
      user = User.new(:name => 'Nick', :email => 'test@test.com', :password => 'password', :password_confirmation => 'password1')
      user.save
      user.errors.should include :password
    end

    it "user should not save without a valid email address" do
      user = User.new(:name => 'Nick', :email => 'test', :password => 'password', :password_confirmation => 'password')
      user.save
      user.errors.should include :email
    end

    it "user should not save with a non-unique email address" do
      User.create(:name => 'Nick', :email => 'test@test.com', :password => 'password', :password_confirmation => 'password')
      user2 = User.new(:name => 'Nick', :email => 'test@test.com', :password => 'password', :password_confirmation => 'password')
      user2.save
      user2.errors.should include :email
    end

    it "user should save with valid credentials" do
      user = User.new(:name => 'Nick', :email => 'test@test.com', :password => 'password', :password_confirmation => 'password')
      user.save
      user.should be_valid
    end
  end
  
  describe "cookies should function correctly" do
    before(:each) do
      @user = User.create!(:name => 'Nick', :email => 'test@test.com', :password => 'password', :password_confirmation => 'password')
    end
    
    it "should have a cookie store method" do
      @user.should respond_to(:remember_me!)
    end
    
    it "should have a remember token" do
      @user.should respond_to(:remember_token) 
    end
    
    it "should set the remember token" do
      @user.remember_me!
      @user.remember_token.should_not be_nil
    end
  end
  
end