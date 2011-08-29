class UserMailer < ActionMailer::Base
  default :from => "from@example.com"
  
  def welcome_email(member, existing_member, email)
    @member = member
    @url  = "http://www.house-accounts.com/register/?member_token=#{member.member_token}"
    @existing_member = existing_member
    mail(:to => email, :subject => "Welcome to House Accounts")
  end
  
  def forgotten_password_email(user)
    @user = user
    @url = "http://www.house-accounts.com/password_reset/?user_token=#{user.user_token}"
    mail(:to => user.email, :subject => "House Accounts - Forgotten Password")
  end
end
