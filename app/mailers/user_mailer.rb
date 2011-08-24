class UserMailer < ActionMailer::Base
  default :from => "from@example.com"
  
  def welcome_email(member, email)
    @member = member
    @url  = "http://www.house-accounts.com"
    mail(:to => email, :subject => "Welcome to House Accounts")
  end
end
