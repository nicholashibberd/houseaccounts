require 'spec_helper'

describe MembersHelper do
  
  describe '#summary_for_member' do
    before(:each) do
      @member = mock_model(Member)
      @other_member = mock_model(Member)
      @other_member.stub!(:name).and_return("Nick")
    end
    
    it "should provide the correct summary when the balance is positive" do
      @member.stub!(:balance_compared_to).and_return(1000)
      helper.summary_for_member(@member, @other_member).should eql("is owed £10.00 by Nick")
    end

    it "should provide the correct summary when the balance is negative" do
      @member.stub!(:balance_compared_to).and_return(-1000)
      helper.summary_for_member(@member, @other_member).should eql("owes Nick £10.00")
    end

    it "should provide the correct summary when the balance is zero" do
      @member.stub!(:balance_compared_to).and_return(0)
      helper.summary_for_member(@member, @other_member).should eql("is square with Nick")
    end
  end
  
  describe '#summary_for_current_user' do
    
    describe 'member is current user' do
      before(:each) do
        @user = mock_model(User)
        @member = mock_model(Member)
        @member.stub!(:user).and_return(@user)
        @other_member = mock_model(Member)
        @other_member.stub!(:name).and_return("Nick")
        helper.should_receive(:current_user).and_return(@user)
      end
    
      it "should provide the correct summary when the balance is positive" do
        @member.stub!(:balance_compared_to).and_return(1000)
        helper.summary_for_current_user(@member, @other_member).should eql("Nick owes me £10.00")
      end

      it "should provide the correct summary when the balance is negative" do
        @member.stub!(:balance_compared_to).and_return(-1000)
        helper.summary_for_current_user(@member, @other_member).should eql("I owe Nick £10.00")
      end

      it "should provide the correct summary when the balance is zero" do
        @member.stub!(:balance_compared_to).and_return(0)
        helper.summary_for_current_user(@member, @other_member).should eql("I am square with Nick")
      end
    end

    describe 'member is not current user' do
      before(:each) do
        @user = mock_model(User)
        @user2 = mock_model(User)
        @member = mock_model(Member)
        @member.stub!(:user).and_return(@user2)
        @other_member = mock_model(Member)
        @other_member.stub!(:name).and_return("Nick")
        helper.should_receive(:current_user).and_return(@user)
      end
    
      it "should provide the correct summary when the balance is positive" do
        @member.stub!(:balance_compared_to).and_return(1000)
        helper.summary_for_current_user(@member, @other_member).should eql("is owed £10.00 by Nick")
      end

      it "should provide the correct summary when the balance is negative" do
        @member.stub!(:balance_compared_to).and_return(-1000)
        helper.summary_for_current_user(@member, @other_member).should eql("owes Nick £10.00")
      end

      it "should provide the correct summary when the balance is zero" do
        @member.stub!(:balance_compared_to).and_return(0)
        helper.summary_for_current_user(@member, @other_member).should eql("is square with Nick")
      end
    end
    
  end
  
end