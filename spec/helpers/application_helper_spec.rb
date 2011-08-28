require 'spec_helper'

describe ApplicationHelper do
  describe '#display_price' do
    it "returns the correct display price" do
      helper.display_price(999).should eq('£999.00')
    end
  end
  
  describe '#display_balance' do
    it "returns -- if the balance is zero" do
      helper.display_balance(nil).should eq('--')
    end
  end
  
  describe '#display_price_for_form' do
    it "returns the correct display price" do
      helper.display_price_for_form(999).should eq('9.99')
    end
  end
end