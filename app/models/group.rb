class Group < ActiveRecord::Base
  attr_accessor :member_name, :current_user_id
  has_many :members
  has_many :users, :through => :members
  has_many :payments, :through => :members
  
  before_create :generate_group_token
  after_create :assign_member_on_create
  
  validates_presence_of :name, :on => :create
  validates_presence_of :current_user_id, :on => :create
  validates_presence_of :member_name, :on => :create
  
  def get_member(user)
    members.select {|member| member.user == user}.first
  end
  
  def generate_group_token(length=8)
    alphanumerics = ('a'..'z').to_a.concat(('A'..'Z').to_a.concat(('0'..'9').to_a))
    unless Group.find_by_group_token(alphanumerics)
      self.group_token = alphanumerics.sort_by{rand}.to_s[0..length]
    else
      generate_group_token
    end
  end
    
  def assign_member_on_create
    member = Member.create(:name => member_name, :group_id => id, :user_id => current_user_id)
    self.owner_id = member.id
  end
  
  def add_member(member_name, user_id)
    Member.create(:name => member_name, :group_id => id, :user_id => user_id)
  end
  
end
