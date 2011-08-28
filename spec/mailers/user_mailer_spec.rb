require "spec_helper"

describe UserMailer do
  it "should not raise an error when sending a message" do
    @member = Factory(:member, :name => 'Member1')
    @existing_member = Factory(:member, :name => 'Member2')
    email = 'test@test.com'
    lambda { UserMailer.welcome_email(@member, @existing_member, email) }.should_not raise_error
  end
end
