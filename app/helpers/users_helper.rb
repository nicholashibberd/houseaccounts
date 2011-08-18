module UsersHelper
  def set_user_cookie(user)
    user.remember_me!
    cookies[:remember_token] = {:value => user.remember_token, :expires => 20.years.from_now.utc}
    self.current_user = user
  end
  
  def current_user=(user)
   @current_user = user
  end
  
  def current_user
    @current_user ||= user_from_remember_token
  end
  
  def user_from_remember_token
    remember_token = cookies[:remember_token]
    User.find_by_remember_token(remember_token) unless remember_token.nil?
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end
  
  def user_group_summary(group, &block)
    if group.members.empty?
      content_tag(:div, "No other members have been added to this group")
    elsif group.payments.empty?
      content_tag(:div, "No payments have been added for this group")
    else
      content_tag(:div, nil, &block)
    end
  end
  
  def user_groups(user, &block)
    if user.groups.empty?
      content_tag(:div, "You haven't created or joined any groups yet!", :class => 'subsection')
    else
      content_tag(:div, nil, &block)
    end
  end
  
end
