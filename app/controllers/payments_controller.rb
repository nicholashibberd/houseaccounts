class PaymentsController < ApplicationController
  layout 'blank'
  def create
    member = Member.find(params[:payment][:member_id])
    @payment = Payment.new(params[:payment])
    
    if @payment.save
      redirect_to member_path(member)
    else
      #flash_display(@payment.errors) if @payment.errors
      @payment.errors.each do |error, message|
        flash_display(error)
      end
        #flash[error] = "#{error} #{message}".titleize
      #end
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
      #flash_display(@payment.errors) if @payment.errors
      @payment.errors.each do |error, message|
        flash_display(error)
      end
        #flash[error] = "#{error} #{message}".titleize
      #end
      redirect_to member_path(member)
    end
  end
  
  def new
    @member = Member.find(params[:member_id])
    @payment = @member.payments.build
  end
  
  def edit
    @member = Member.find(params[:member_id])
    @payment = Payment.find(params[:id])
  end
  
  def destroy
    member = Member.find(params[:member_id])
    payment = Payment.find(params[:id])
    payment.liable_members.clear
    payment.destroy
    redirect_to member_path(member)
  end
  
end