class CreateComponentCategories < ActiveRecord::Migration
  def change
    create_table :component_categories do |t|

      t.timestamps
    end
  end
end
