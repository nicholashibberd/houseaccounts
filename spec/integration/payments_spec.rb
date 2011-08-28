require 'integration_spec_helper'
require 'spec_helper'

describe "Payments" do
  before(:each) do
    login_user_blank
    @group = Factory(:group, :current_user_id => 1, :member_name => 'Nick')
    @member = Factory(:member, :group_id => @group.id, :name => 'Adam')
    visit new_member_payment_path(:member_id => @member.id)
  end

  it "should raise a flash erro" do
    click_button
    response.should have_selector('#flash')
  end
  
  it "should correctly save the payment" do
    fill_in "payment_amount_parse", :with => 999
    fill_in "description", :with => 'Test description'
    check "payment_liable_member_ids_"
    click_button
    response.should_not have_selector('#flash')
  end

  it "should correctly save the payment when the amount has a decimal point" do
    fill_in "payment_amount_parse", :with => 9.99
    fill_in "description", :with => 'Test description'
    check "payment_liable_member_ids_"
    click_button
    response.should be_success
  end

end