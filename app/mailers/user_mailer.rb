class UserMailer < ActionMailer::Base
  default :from => "from@example.com"
  
  def welcome_email(member, existing_member, email)
    @member = member
    @url  = "http://www.house-accounts.com/?member_token=#{member.member_token}"
    @existing_member = existing_member
    
    mail(:to => email, :subject => "Welcome to House Accounts")
  end
end
