require 'spec_helper'

require 'webrat'

Webrat.configure do |config|
  config.mode = :rails
end

def login_user_blank(email = 'test@test.com', password = 'password')
  user = Factory(:user, {:email => email, :password => password})
  visit signin_url
  fill_in "Email",        :with => email
  fill_in "Password",     :with => password
  click_button
end

def login_user(user)
  visit signin_url
  fill_in "Email",        :with => user.email
  fill_in "Password",     :with => user.password
  click_button
end
  