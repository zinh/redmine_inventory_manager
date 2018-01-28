class CreateInventoryProductCustomFields < ActiveRecord::Migration
  def change
    create_table :inventory_product_custom_fields do |t|
      t.integer :product_id, index: true
      t.integer :custom_field_id, index: true
      t.text :custom_field_value
    end
  end
end
