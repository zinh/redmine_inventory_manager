class InventoryCategory < ActiveRecord::Base
  #t.column :name, :string
  #t.column :description, :text
  has_many :inventory_parts, dependent: :destroy
  has_many :inventory_category_custom_fields, dependent: :destroy
  validates_presence_of :name

  # custom_fields_params: {'0' => {type:, label:, require:}}
  def update_or_create_custom_fields(custom_fields_params)
    current_custom_fields = inventory_category_custom_fields.to_a
    custom_fields_params.each do |idx, field|
      next if field['label'].blank?
      if (custom_field = current_custom_fields.find{|current_custom_field| current_custom_field.id == field['id'].to_i})
        custom_field.update_attributes(field_type: field['type'], 
                                       label: field['label'],
                                       require: field['require'].present?)
      else
        inventory_category_custom_fields.create(field_type: field['type'], 
                                                label: field['label'],
                                                require: field['require'].present?)
      end
    end
  end
end
