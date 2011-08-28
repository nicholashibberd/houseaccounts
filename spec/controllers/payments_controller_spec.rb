require 'spec_helper.rb'

describe PaymentsController do
  
  describe "create a new payment" do   
    before(:each) do
      controller.stub!(:signed_in?).and_return(true)
      @group = mock_model(Group)
      @member = mock_model(Member)
      Member.stub!(:find).and_return(@member)
    end
    
    it "should display a flash error if the amount is missing" do
      @payment = mock_model(Payment)
      Payment.should_receive(:new).and_return(@payment)
      @payment.should_receive(:save).and_return(false)
      @payment.stub!(:errors).and_return(:amount => 'should not be nil')
      post :create, :member_id => @member.id, :payment => {:member_id => @member.id}
      flash[:amount].should_not be_nil
    end
    
    it "should redirect to the member page on success" do
      @payment = mock_model(Payment)
      Payment.should_receive(:new).and_return(@payment)
      @payment.should_receive(:save).and_return(true)
      post :create, :member_id => @member.id, :payment => {:member_id => @member.id}
      response.should redirect_to(member_path(@member))
      flash.should be_empty
    end
  end
  
  describe "allow permitted users access" do   
    it "should allow access to the new page" do
      controller.stub!(:signed_in?).and_return(true)
      @member = Factory(:member)
      get :new, :member_id => @member.id
      response.should be_success
    end
  end
  
  describe "update a payment" do
    before(:each) do
      controller.stub!(:signed_in?).and_return(true)
      @group = mock_model(Group)
      @member = mock_model(Member)
      Member.stub!(:find).and_return(@member)
    end
    
    it "should display a flash message if the payment is not valid" do
      @payment = mock_model(Payment)
      @payment.should_receive(:save).and_return(false)
      @payment.stub!(:errors).and_return(:amount => 'should not be nil')
      Payment.should_receive(:find).and_return(@payment)
      @payment.should_receive(:update_attributes).and_return(false)      
      @payment.stub!(:errors).and_return(:amount => 'should not be nil')         
      put :update, :member_id => @member.id, :id => @payment.id, :payment => {:member_id => @member.id}
      flash[:amount].should_not be_nil
    end

    it "should redirect and not show the flash message if the payment is valid" do
      @payment = mock_model(Payment)
      @payment.should_receive(:save).and_return(true)
      Payment.should_receive(:find).and_return(@payment)
      @payment.should_receive(:update_attributes).and_return(true)
      put :update, :member_id => @member.id, :id => @payment.id, :payment => {:member_id => @member.id}
      flash.should be_empty
      
    end
  end
  
  describe "edit payment" do
    it "should access the edit page ok" do
      @payment = mock_model(Payment)
      @member = mock_model(Member)
      controller.stub!(:signed_in?).and_return(true)
      Member.stub!(:find).and_return(@member)
      Payment.stub!(:find).and_return(@payment)
      get 'edit', :member_id => @member.id, :id => @payment.id
      response.should be_success
    end
  end
  
  describe "destroy payment" do
    it "should delete the payment" do
      @payment = mock_model(Payment)
      @member = mock_model(Member)
      @member2 = mock_model(Member)
      controller.stub!(:signed_in?).and_return(true)
      Member.stub!(:find).and_return(@member)
      Payment.stub!(:find).and_return(@payment)
      @payment.should_receive(:liable_members).and_return([@member, @member2])
      delete :destroy, :member_id => @member.id, :id => @payment.id
      response.should redirect_to member_path(@member)
    end
  end
  
end