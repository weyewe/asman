class CreateComponents < ActiveRecord::Migration
  def change
    create_table :components do |t|
      t.string :name 
      t.integer :machine_id 
      t.integer :creator_id 

      t.integer :component_category_id
      t.timestamps
    end
  end
end
