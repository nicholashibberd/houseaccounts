class PagesController < ApplicationController
  skip_before_filter :login_required
  
  def home
    if current_user 
      redirect_to user_path(current_user)
    else
      @user = User.new
      return

    end
  end
  
  def homepage

  end

end
