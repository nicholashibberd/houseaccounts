require 'spec_helper'

describe ApplicationHelper do
  describe '#display_price' do
    it "returns the correct display price" do
      helper.display_price(999).should eq('£9.99')
    end
  end
end