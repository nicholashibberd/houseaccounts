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
end