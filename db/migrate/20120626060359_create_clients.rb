class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.string :contact_person
      t.string :phone_number
      t.string :blackberry_pin
      t.string :email 
      t.string :address 
      t.integer :creator_id 
      
      t.integer :office_id 
      t.timestamps
    end
  end
end
