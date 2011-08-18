module ApplicationHelper
  def display_balance(balance)
    if balance.is_a?(BigDecimal)
      amount = balance.to_f / 100
      display_price(amount)
    else
      '--'
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
  
end
