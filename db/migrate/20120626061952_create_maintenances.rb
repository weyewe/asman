class CreateMaintenances < ActiveRecord::Migration
  def change
    create_table :maintenances do |t|
      t.string :work_order_no
      t.integer :creator_id 
      t.integer :asset_id 
      t.integer :office_id
      
      t.boolean :is_finalized, :default => false
      t.integer :finalizer_id 
      t.text :invoice_url 
      t.datetime :finalization_datetime
      
      t.boolean :is_paid, :default => false 
      t.integer :payment_approver_id 
      t.text :payment_receipt_url 
      t.string :payment_receipt_number
      t.datetime :payment_datetime

      t.timestamps
    end
  end
end
