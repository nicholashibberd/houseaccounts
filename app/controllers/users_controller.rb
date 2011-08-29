class UsersController < ApplicationController
  skip_before_filter :login_required, :except => [:edit, :show]
  include ApplicationHelper
  
  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
    check_user_access(@user)
  end

  def show
    @user = User.find(params[:id])
    check_user_access(@user)
  end
  
  def signin
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      @user.assign_member(params[:member_token]) if !params[:member_token].empty?
      set_user_cookie @user
      redirect_to @user
    else
      @user.errors.each do |error, message|
        flash_display(error, message)
      end
      #redirect_to new_user_path
      render 'new'
    end
  end
  
  def validate
    user = User.authenticate(params[:user][:email], params[:user][:password])
    if user.nil?
      flash[:success] = "Your email/password combination is invalid"
    redirect_to signin_path
    else
      set_user_cookie user
      redirect_to user
    end
  end
  
  def send_password_update_link
    user = User.find_by_email(params[:user][:email])
    if user
      UserMailer.forgotten_password_email(user).deliver
    else
      flash[:error] = "We couldn't find a user with that email address"
    end
  end
  
  def handle_password_reset
    user = User.find_by_user_token(params[:user][:user_token])
    if user.update_attributes(:password => params[:user][:password])
      flash[:success] = 'Your password has been updated'
      redirect_to user_path(user)
    else
      flash[:error] = 'There was an error. Your password has not been updated'
      redirect_to password_reset_path
    end
  end
  
  def signout
    sign_out
    redirect_to signin_path
  end
  
end
