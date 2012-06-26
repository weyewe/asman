class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :asset_no 
      t.integer :creator_id 
      t.integer :client_id 
      t.integer :machine_id 

      t.timestamps
    end
  end
end
