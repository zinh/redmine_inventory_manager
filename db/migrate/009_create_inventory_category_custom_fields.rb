class CreateInventoryCategoryCustomFields < ActiveRecord::Migration
  def change
    create_table :inventory_category_custom_fields do |t|
      t.integer :inventory_category_id, index: true
      t.integer :field_type
      t.string :label
      t.boolean :require
    end
  end
end
