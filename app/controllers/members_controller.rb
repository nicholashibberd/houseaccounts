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
    @existing_member = Member.find(params[:existing_member_id])
    if @member.save
      if email = params[:email]
        #check that the email is valid and send out the email
        UserMailer.welcome_email(@member, @existing_member, email).deliver
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
      flash[:error] = "#{member.name.titleize} still has an unsettled balance!"
    end
    redirect_to group_path(member.group)
  end
  
  def send_email
    group = Group.find(params[:group_id])
    existing_member = group.get_member(current_user)
    member = Member.find(params[:member_id])
    email = params[:email_address]
    if UserMailer.welcome_email(member, existing_member, email).deliver
      flash[:success] = "A welcome email has been sent to #{member.name.titleize}!"
    else
      flash[:error] = "There was an error. The email has not been sent"
    end
    redirect_to edit_group_path(group)
  end

end
