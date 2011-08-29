class AddUserTokenToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :user_token, :string
  end

  def self.down
    remove_column :users, :user_token
  end
end
