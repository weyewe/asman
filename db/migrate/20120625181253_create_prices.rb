class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.decimal :amount , :precision => 11, :scale => 2 , :default => 0 
      # 10^8 == 99,999,999 rupiah or 99,999,999 USD.. heheheh 
      
      t.integer :creator_id 
      t.integer :spare_part_id 
      t.boolean :is_active 
      t.timestamps
    end
  end
end
