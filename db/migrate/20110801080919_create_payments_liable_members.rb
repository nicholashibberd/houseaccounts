class CreatePaymentsLiableMembers < ActiveRecord::Migration
  def self.up
    create_table :payments_liable_members, :id => false do |t|
      t.integer :payment_id
      t.integer :member_id
    end
  end

  def self.down
    drop_table :payments_liable_members
  end
end