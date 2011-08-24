class MembersController < ApplicationController
  def new
  end

  def edit
    @member = Member.find(params[:id])
    check_user_access(@member)
  end

  def show
    @member = Member.find(params[:id])
    @group = @member.group
    @payment = Payment.new
    check_user_access(@member)
  end
  
  def create
    @member = Member.new(params[:member])
    if @member.save
      if email = params[:email]
        #check that the email is valid and send out the email
        UserMailer.welcome_email(@member, email).deliver
      end
      redirect_to member_path(@member)
    else
      redirect_to user_path(current_user)
    end
  end
  
  def destroy
    member = Member.find(params[:id])
    if member.overall_balance == 0
      member.destroy
    else
      flash[:error] = "#{member.name.titleize} still has a unsettled balance!"
    end
    redirect_to group_path(member.group)
  end

end
