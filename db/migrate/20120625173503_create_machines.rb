class CreateMachines < ActiveRecord::Migration
  def change
    create_table :machines do |t|
      t.string :model_name 
      t.integer :machine_category_id 
      t.integer :office_id 
      t.integer :creator_id 
      
      t.timestamps
    end
  end
end
