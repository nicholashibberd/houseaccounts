require 'spec_helper'

describe MembersHelper do
  
  describe 'summary_for_member not the current user' do
    before(:each) do
      @member = mock_model(Member)
      @other_member = mock_model(Member)
      @other_member.stub!(:name).and_return("Nick")
      @user = Factory(:user)
      @current_user = mock_model(User)
      @member.should_receive(:user).twice.and_return(@user)
      helper.should_receive(:current_user).and_return(@current_user)
    end
    
    it "should provide the correct summary when the balance is positive" do
      @member.stub!(:balance_compared_to).and_return(1000)
      helper.summary_for_member(@member, @other_member).should eql('<div class="member_summary owed">is owed £10.00 by Nick</div>')
    end

    it "should provide the correct summary when the balance is negative" do
      @member.stub!(:balance_compared_to).and_return(-1000)
      helper.summary_for_member(@member, @other_member).should eql('<div class="member_summary owes">owes Nick £10.00</div>')
    end

    it "should provide the correct summary when the balance is zero" do
      @member.stub!(:balance_compared_to).and_return(0)
      helper.summary_for_member(@member, @other_member).should eql('<div class="member_summary square">is square with Nick</div>')
    end
  end
  
  describe '#summary_for_member who is current user' do
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
      helper.summary_for_member(@member, @other_member).should eql('<div class="member_summary owed">Nick owes me £10.00</div>')
    end

    it "should provide the correct summary when the balance is negative" do
      @member.stub!(:balance_compared_to).and_return(-1000)
      helper.summary_for_member(@member, @other_member).should eql('<div class="member_summary owes">I owe Nick £10.00</div>')
    end

    it "should provide the correct summary when the balance is zero" do
      @member.stub!(:balance_compared_to).and_return(0)
      helper.summary_for_member(@member, @other_member).should eql('<div class="member_summary square">I am square with Nick</div>')
    end    
  end
    
end