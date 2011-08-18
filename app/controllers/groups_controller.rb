class GroupsController < ApplicationController
  def new
    
  end

  def edit
    @group = Group.find(params[:id])
    check_user_access(@group)
  end

  def show   
    @group = Group.find(params[:id])
    check_user_access(@group)
  end

  def index
  end
  
  def join
    @user = User.find(params[:user_id])
  end
  
  def add
    @user = User.find(params[:user_id])
  end
  
  def join_new_group
    group = Group.find_by_group_token(params[:group_token])
    group.add_member(params[:member_name], current_user.id)
    redirect_to group_path(group)
  end
  
  def add_new_group
    group = Group.new(params[:group])
    if group.save
      redirect_to group
    else
      flash[:error] = "Group did not create"
      redirect_to user_path(current_user)
    end
  end
  
end
