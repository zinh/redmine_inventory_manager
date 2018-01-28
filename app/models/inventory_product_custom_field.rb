class InventoryProductCustomField < ActiveRecord::Base
  unloadable
  belongs_to :product, class_name: 'InventoryPart', foreign_key: :product_id
  belongs_to :inventory_category_custom_field, class_name: 'InventoryCategoryCustomField', foreign_key: :custom_field_id
end
