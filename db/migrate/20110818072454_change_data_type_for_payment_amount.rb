class ChangeDataTypeForPaymentAmount < ActiveRecord::Migration
  def self.up
    change_table :payments do |t|
      t.change :amount, :big_decimal
    end
  end

  def self.down
    change_table :payments do |t|
      t.change :amount, :integer
    end
  end
end
