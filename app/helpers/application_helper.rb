module ApplicationHelper
  def display_balance(balance)
    if balance.nil? 
      '--'
    else
      amount = balance.to_f / 100
      display_price(amount)      
    end
  end
  
  def display_price(amount)
    number_to_currency amount, :unit => '£', :separator => ".", :delimiter => ","
  end
  
  def display_price_for_form(amount)
    if amount
      new_value = BigDecimal("#{amount}") / BigDecimal("100")
      number_to_currency new_value, :unit => '', :separator => ".", :delimiter => ","
    end
  end
  
  def display_top_nav
    if signed_in?
      render 'layouts/top_nav'
    end
  end
  
  def user_status(user)
    if user
      content_tag(:div, (link_to "#{current_user.name}: Sign out", signout_path), :id => 'signout_link')
    else
      content_tag(:div, (link_to "Sign in", signin_path), :id => 'signout_link')
    end
  end
  
  def email_valid?(email)
    email =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  end
  
end
