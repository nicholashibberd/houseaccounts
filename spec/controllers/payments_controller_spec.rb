require 'spec_helper.rb'

describe PaymentsController do
  
  describe "create a new payment" do   
    it "should redirect to the member page on success" do
      controller.stub!(:signed_in?).and_return(true)
      @group = mock_model(Group)
      @member = mock_model(Member)
      @member.should_receive(:group).and_return(@group)
      Member.stub!(:find).and_return(@member)
      
      @payment = mock_model(Payment)
      Payment.should_receive(:new).and_return(@payment)
      @payment.should_receive(:save).and_return(true)
      
      post :create, :payment => {:member_id => @member.id}
      response.should redirect_to(member_path(@member))
    end
  end
  
  describe "allow permitted users access" do   
    it "should allow access to the new page" do
      controller.stub!(:signed_in?).and_return(true)
      get 'new'
      response.should be_success
    end
  end
  
end