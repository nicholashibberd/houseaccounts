class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :login_required
  include UsersHelper
  
  def login_required
    if signed_in?
      return true
    end
    flash[:warning]='Please login to continue'
    redirect_to signin_path
  end
  
  def check_user_access(instance)
    case instance
      when User then handle_user_access(instance == current_user)  
      when Group then handle_user_access(instance.users.include?(current_user))
      when Member then handle_user_access(instance.group.users.include?(current_user))
    end
  end
  
  def handle_user_access(access)
    if access
      return
    else          
      flash[:error] = "You cannot access this page"
      redirect_to current_user
    end
  end
  
  def flash_display(error, message)
    case error
      when :liable_member_ids then flash[:liable_members] = 'Please add some other members for this payment'
      when :amount then flash[:amount] = 'Please enter an amount for this payment'
      when :description then flash[:description] = 'Please leave a description for this payment'
      when :password then flash[:password] = "#{error.to_s.titleize} #{message}"
      when :email then flash[:email] = "#{error.to_s.titleize} #{message}"  
      when :name then flash[:name] = "#{error.to_s.titleize} #{message}"
    end
  end
  
end
