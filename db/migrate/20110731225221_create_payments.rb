class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.string :description
      t.integer :amount
      t.integer :user_id
      t.integer :group_id
      t.date :date

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
