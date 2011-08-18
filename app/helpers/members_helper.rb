module MembersHelper
  def summary_for_member(member, other_member)
    balance = member.balance_compared_to(other_member)
    if balance > 0
      "is owed #{display_balance(balance)} by #{other_member.name}"
    elsif balance < 0
      "owes #{other_member.name} #{display_balance(balance.abs)}"
    elsif balance == 0  
      "is square with #{other_member.name}"
    end
  end

  def summary_for_current_user(member, other_member)
    member.user ? member_is_current_user = (member.user.id == current_user.id) : nil
    balance = member.balance_compared_to(other_member)
    if balance > 0
      member_is_current_user ? "#{other_member.name} owes me #{display_balance(balance)}" : "is owed #{display_balance(balance)} by #{other_member.name}"
    elsif balance < 0
      member_is_current_user ? "I owe #{other_member.name} #{display_balance(balance.abs)}" : "owes #{other_member.name} #{display_balance(balance.abs)}"
    else
      member_is_current_user ? "I am square with #{other_member.name}" : "is square with #{other_member.name}"
    end
  end
  
  def last_10_payments(member, &block)
    member.user ? member_is_current_user = (member.user.id == current_user.id) : nil
    statement = member_is_current_user ? "You have not made any payments yet" : "#{member.name.titleize} has not made any payments yet"
    if member.payments.empty?
      content_tag(:div, statement, :class => 'subsection')
    else
      content_tag(:div, nil, &block)
    end
  end
  
end
