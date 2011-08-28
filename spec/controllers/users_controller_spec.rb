require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do
  
  describe "allow permitted users access" do   
    before(:each) do
      @user = mock_model(User)
      User.stub!(:find).and_return(@user)
      controller.stub!(:signed_in?).and_return(true)
      controller.stub!(:current_user).and_return(@user)
    end
    
    it "should allow access to the show page" do
      get 'show', :id => @user.id
      response.should be_success
    end

    it "should allow access to the edit page" do
      get 'edit', :id => @user.id
      response.should be_success
    end
  end
  
  
  describe "GET 'new'" do 
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end
  
  describe 'failure to create new user' do
    before(:each) do
      @attr = {:name => "", :email => "", :password => "", :password_confirmation => ""}
      @user = Factory.build(:user, @attr)
      User.stub!(:new).and_return(@user)
      @user.should_receive(:save).and_return(false)
    end
    
    it "should redirect to the 'new' page" do
      post :create, :user => @attr
      response.should render_template('new')
    end
    
  end
    
  describe 'successful creation of new user' do
    before(:each) do 
      @attr = { :name => "New User", :email => "user@example.com", :password => "foobar", :password_confirmation => "foobar" } 
      @user = Factory(:user, @attr)
      User.stub!(:new).and_return(@user)
      @user.should_receive(:save).exactly(2).times.and_return(true) 
    end
    
    it "should redirect to the user show page" do
      post :create, :user => @attr, :member_token => ""
      response.should redirect_to(user_path(@user))
    end
  end
  
  describe 'validate a user when logging in' do
    before(:each) do 
      @attr = { :name => "Existing User", :email => "user@example.com", :password => "foobar", :password_confirmation => "foobar" } 
      @user = Factory(:user, @attr)
    end
    
    it "should deny entry when credentials are invalid" do
      User.stub!(:authenticate).and_return(nil)
      post :validate, :user => @attr
      response.should redirect_to(signin_path)
    end
    
    it "should correctly redirect when the credentials are valid" do
      User.stub!(:authenticate).and_return(@user)
      post :validate, :user => @attr
      response.should redirect_to(user_path(@user))
    end
    
    it "should set the current user" do
      post :validate, :user => @attr
      controller.current_user.should == @user
      controller.should be_signed_in
    end
    
  end
  
  describe "signin" do 
    describe "failure" do
      before(:each) do
        @attr = { :email => "email@example.com", :password => "password" }
        User.should_receive(:authenticate).with(@atrr[:email], @attr[:password]).and_return(nil)
      end
    end
  end
  
  describe "login service" do
    before(:each) do
      @user = Factory(:user)
      controller.stub!(:current_user).and_return(@user)
    end
    
    it "should redirect non-signed in users to the signin path" do
      controller.stub!(:signed_in?).and_return(false)
      get 'show', :id => @user.id
      response.should redirect_to(signin_path)
      flash[:warning].should =~ /Please login to continue/
    end
    
    it "should allow signed in users to the page they requested" do
      controller.stub!(:signed_in?).and_return(true)
      get 'show', :id => @user.id
      response.should be_success
    end
    
    it "should redirect back to the user page when accessing another users page" do
      controller.stub!(:signed_in?).and_return(true)
      @user2 = mock_model(User)
      User.stub!(:find).and_return(@user2)
      get 'show', :id => @user2.id
      response.should redirect_to(user_path(@user))
      flash[:error].should =~ /You cannot access this page/
    end
  end
  
  describe "signout" do
    it "should sign the user out and redirect to the signin path" do
      post :signout
      response.should redirect_to(signin_path)
    end
  end
  
  
end