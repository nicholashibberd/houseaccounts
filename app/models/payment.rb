class Payment < ActiveRecord::Base
  belongs_to :member
  has_and_belongs_to_many :liable_members, :class_name => 'Member', :association_foreign_key => 'member_id', :join_table => 'payments_liable_members'
  #has_many :liable_members
  #has_many :members, :through => :liable_members
  
  attr_accessor :liable_member_ids

  validates_presence_of :amount
  validates_presence_of :member_id
  validates_presence_of :description
  validates_presence_of :liable_member_ids
  
  before_save :set_payment_details
  before_update :update_payment_details
  
  def set_payment_details
    self.liable_member_ids.each do |member_id|
      add_member_to_payment(member_id)
    end
  end
  
  def update_payment_details
    self.liable_members.clear
    set_payment_details
  end
  
  def add_member_to_payment(member_id)
    member = Member.find(member_id.to_i)
    liable_members << member
  end
  
  def spend_per_liable_member
    amount / liable_members.size
  end
  
  def amount_parse=(amount)
    if amount.include?(".")
      self.amount = amount.gsub(".", "")
    else
      self.amount = BigDecimal("#{amount}") * BigDecimal('100')
    end
  end
  
  def amount_parse
    self.amount
  end
end
