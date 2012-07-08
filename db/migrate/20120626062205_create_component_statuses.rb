class CreateComponentStatuses < ActiveRecord::Migration
  def change
    create_table :component_statuses do |t|
      t.integer :maintenance_id 
      t.integer :component_id 
      t.boolean :status  # ok, not ok , 
      t.text :description 
      
      t.integer :replacement_spare_part_id 
      
      t.integer :creator_id 
      
      t.integer :price_id 

      t.timestamps
    end
  end
end
