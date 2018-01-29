module InventoryHelper
  def custom_field_label(custom_field_id)
    @all_custom_fields ||= InventoryCategoryCustomField.all
    @all_custom_fields.detect{ |f| f.id == custom_field_id }.try(:label)
  end
end
