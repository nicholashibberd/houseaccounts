# -*- coding: utf-8 -*-
require 'spec_helper'

describe Payment do
  
  describe 'payment should save with correct validations' do 
    it "payment should not save without an amount" do
      payment = Payment.new(:member_id => 1, :group_id => 1)
      payment.save
      payment.errors.should include :amount
    end

    it "payment should not save without a member_id" do
      payment = Payment.new(:amount => 999, :member_id => 1)
      payment.save
      payment.errors.should include :group_id
    end

    it "payment should not save without a group_id" do
      payment = Payment.new(:amount => 999, :group_id => 1)
      payment.save
      payment.errors.should include :member_id
    end

    it "payment should be added to the members payment" do
      member = Factory(:member)
      payment = Payment.create(:amount => 999, :member_id => member.id, :group_id => 1, :liable_member_ids => [member.id])
      member.payments.last.should eql(payment)
    end

    it "payment should assign liable members" do
      member = Factory(:member, :name => 'Member1')
      member2 = Factory(:member, :name => 'Member2')
      payment = Payment.create(:amount => 999, :member_id => member.id, :group_id => 1, :liable_member_ids => [member.id, member2.id])
      payment.liable_members.should eql([member, member2])
    end

    it "payment should amend the balances correctly" do
      member = Factory(:member, :name => 'Member1')
      member2 = Factory(:member, :name => 'Member2')
      payment = Payment.create(:amount => 200, :member_id => member.id, :group_id => 1, :liable_member_ids => [member.id, member2.id])
      member.balance_compared_to(member2).should eql(100)
    end
  end
end
    
