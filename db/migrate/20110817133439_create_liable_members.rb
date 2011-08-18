class CreateLiableMembers < ActiveRecord::Migration
  def self.up
    create_table :liable_members do |t|
      t.integer :member_id
      t.integer :payment_id

      t.timestamps
    end
  end

  def self.down
    drop_table :liable_members
  end
end
