class UsersController < ApplicationController
  skip_before_filter :login_required, :except => [:edit, :show]
  #layout 'signed_out', :only => :signin, :new
  layout :choose_layout
  
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
      set_user_cookie @user
      redirect_to @user
    else
      @user.errors.each do |error, message|
        flash[:error] = "#{error} #{message}".titleize
      end
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
  
  def signout
    sign_out
    redirect_to signin_path
  end
  
  def choose_layout    
    if [ 'signin', 'new' ].include? action_name
      'signed_out'
    else
      'application'
    end
  end

end
