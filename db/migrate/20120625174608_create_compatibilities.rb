class CreateCompatibilities < ActiveRecord::Migration
  def change
    create_table :compatibilities do |t|
      t.integer :spare_part_id 
      t.integer :component_id 
      t.timestamps
    end
  end
end
