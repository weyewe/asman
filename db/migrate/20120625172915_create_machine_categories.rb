class CreateMachineCategories < ActiveRecord::Migration
  def change
    create_table :machine_categories do |t|
      t.string :name 
      t.integer :office_id
      t.integer :creator_id 

      t.timestamps
    end
  end
end
