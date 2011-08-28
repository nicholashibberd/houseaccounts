class Member < ActiveRecord::Base
  has_many :payments
  has_and_belongs_to_many :liable_payments, :class_name => 'Payment', :association_foreign_key => 'payment_id', :join_table => 'payments_liable_members'
  #has_many :payments
  belongs_to :user
  belongs_to :group
  
  validates_uniqueness_of :name, :case_sensitive => false, :scope => :group_id
  
  before_create :generate_member_token
  
  def other_members
    group.members.select {|member| member != self}
  end
  
  def spend_for_member(member)
    total_payments = payments_for_member(member).map(&:spend_per_liable_member)
    BigDecimal("#{total_payments.inject {|a,b| a + b }}")
  end
  
  def payments_for_member(member)
    payments.select {|payment| payment.liable_members.include?(member)}
  end
  
  def balance_compared_to(member)
    spend_for_member(member) - member.spend_for_member(self)
  end
  
  def generate_member_token(length=8)
    alphanumerics = ('a'..'z').to_a.concat(('A'..'Z').to_a.concat(('0'..'9').to_a))
    unless Member.find_by_member_token(alphanumerics)
      self.member_token = alphanumerics.sort_by{rand}.to_s[0..length]
    else
      generate_member_token
    end
  end
  
  def liability_for_payment(payment)
    owes_for_payment?(payment) ? payment.spend_per_liable_member : nil
  end
  
  def owes_for_payment?(payment)
    payment.liable_members.include?(self)
  end
  
  def last_10_payments
    payments.order('created_at DESC').first(10)
  end
  
  def all_payments
    payments.order('created_at DESC')
  end
  
  def overall_balance
    total = other_members.inject(0) do |total, other_member|
      total + balance_compared_to(other_member)
    end    
  end
end
