class InventoryCategoryCustomField < ActiveRecord::Base
  unloadable
  belongs_to :inventory_category
  enum field_type: { text_field: 1 }
end
