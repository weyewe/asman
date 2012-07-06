class CreateSpareParts < ActiveRecord::Migration
  def change
    create_table :spare_parts do |t|
      t.string :part_code 
      t.integer :office_id 
      t.integer :creator_id
      
      t.integer :component_category_id 
      
      t.boolean :is_active, :default => true 
      t.integer :destroyer_id  

      t.timestamps
    end
  end
end
