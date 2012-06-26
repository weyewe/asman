class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      .decimal :amount , :precision => 11, :scale => 2 , :default => 0 
      # 10^8 == 99,999,999 rupiah or 99,999,999 USD.. heheheh 
      t.timestamps
    end
  end
end
