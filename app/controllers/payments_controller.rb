class PaymentsController < ApplicationController
  #layout 'blank'
  def create
    member = Member.find(params[:payment][:member_id])
    @payment = Payment.new(params[:payment])
    
    if @payment.save
      redirect_to member_path(member)
    else
      @payment.errors.each do |error, message|
        flash_display(error, message)
      end
      redirect_to member_path(member)
    end
  end
  
  def update
    member = Member.find(params[:payment][:member_id])
    @payment = Payment.find(params[:id])
    @payment.update_attributes(params[:payment])
    if @payment.save
      redirect_to member_path(member)
    else
      @payment.errors.each do |error, message|
        flash_display(error, message)
      end
      redirect_to member_path(member)
    end
  end
  
  def new
    @member = Member.find(params[:member_id])
    @payment = @member.payments.build
    @heading = 'New Payment'
  end
  
  def edit
    @member = Member.find(params[:member_id])
    @payment = Payment.find(params[:id])
    @heading = 'Edit Payment'    
  end
  
  def destroy
    member = Member.find(params[:member_id])
    payment = Payment.find(params[:id])
    payment.liable_members.clear
    payment.destroy
    redirect_to member_path(member)
  end
  
end