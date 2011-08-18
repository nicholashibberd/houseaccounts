class AddMemberIdToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :member_id, :integer
  end

  def self.down
    remove_column :payments, :member_id
  end
end
