class AddMemberTokenToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :member_token, :string
  end

  def self.down
    remove_column :members, :member_token
  end
end
