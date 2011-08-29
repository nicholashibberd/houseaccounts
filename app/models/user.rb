class User < ActiveRecord::Base
  has_many :members
  has_many :groups, :through => :members
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation, :status, :site_id
  
  EmailRegex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates_format_of	:email, :with => EmailRegex
  validates_uniqueness_of :email, :case_sensitive => false
  validates_confirmation_of :password
  
  validates_presence_of :name, :on => :create
  validates_presence_of :password, :on => :create
  validates_length_of	:password, :within => 6..40, :on => :create
  
  before_save :encrypt_password
  before_create :generate_user_token
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)
    user = User.find_by_email(email)
     return nil if user.nil?
     return user if user.has_password?(submitted_password)
  end

  def remember_me!
    self.remember_token = encrypt("#{salt}--#{id}")
    save(:validate => false)
  end
  
  def assign_member(member_token)
    member = Member.find_by_member_token(member_token)
    member.update_attributes(:user_id => self.id)    
  end
  
  def generate_user_token(length=8)
    alphanumerics = ('a'..'z').to_a.concat(('A'..'Z').to_a.concat(('0'..'9').to_a))
    unless User.find_by_user_token(alphanumerics)
      self.user_token = alphanumerics.sort_by{rand}.to_s[0..length]
    else
      generate_user_token
    end
  end
  
  private
  
  def encrypt_password
    unless password.nil?
      self.salt = make_salt
      self.encrypted_password = encrypt(password)
    end
  end
  
  def encrypt(string) 
    secure_hash("#{salt}#{string}")
  end
  
  def make_salt
    secure_hash("#{Time.now.utc}#{password}")
  end
  
  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end    
  
end
