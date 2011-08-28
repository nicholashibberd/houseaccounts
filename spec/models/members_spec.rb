require 'spec_helper'

describe Member do
  describe 'other members' do
    it "should return the other members in the group" do
      group = Factory(:group, :current_user_id => 1, :member_name => 'David')
      member = Factory(:member, :group_id => group.id, :name => 'Adam')
      member2 = Factory(:member, :group_id => group.id, :name => 'Steve')
      group.members.first.other_members.should eql([member, member2])
    end
  end
  
  describe "overall_balance" do
    it "should return the correct overall balance" do
      group = Factory(:group, :current_user_id => 1, :member_name => 'David')
      member = Factory(:member, :group_id => group.id, :name => 'Adam')
      member2 = Factory(:member, :group_id => group.id, :name => 'Steve')
      payment = Factory(:payment, :amount => 2000, :description => 'Test description', :member_id => member.id, :liable_member_ids => [member.id, member2.id], :date => Date.today)
      member.overall_balance.should eql(1000)
    end
  end
end