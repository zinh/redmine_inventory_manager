class InventoryPart < ActiveRecord::Base
  #t.column :part_number, :string
  #t.column :manufacturer, :string
  #t.column :inventory_category_id, :integer
  #t.column :description, :text
  #t.column :value, :float
  #t.column :status, :integer

  attr_writer :input_custom_fields
  has_many :inventory_movements
  belongs_to :inventory_category
  has_many :product_custom_fields, class_name: 'InventoryProductCustomField', foreign_key: :product_id, dependent: :destroy
  validates_presence_of :part_number, :inventory_category, :value, :status
  validates_uniqueness_of :part_number
  validate :presence_of_custom_fields

  # custom_fields: {id => value}
  def update_custom_fields(custom_fields)
    custom_fields.each do |field_id, field_value|
      custom_field = InventoryProductCustomField.find_or_initialize_by(product_id: id, custom_field_id: field_id)
      custom_field.update_attributes(custom_field_value: field_value)
    end
  end

  def custom_fields_with_values
    current_custom_values = product_custom_fields.each_with_object({}){ |obj, memo| memo[obj.custom_field_id] = obj.custom_field_value }
    all_custom_fields = InventoryCategory.includes(:inventory_category_custom_fields).all
      .each_with_object({}) do |obj, memo| 
        memo[obj.id] = obj.inventory_category_custom_fields.map do |custom_field| 
          if current_custom_values[custom_field.id].present?
            custom_field.slice(:id, :label, :require).merge(current_value: current_custom_values[custom_field.id])
          else
            custom_field.slice(:id, :label, :require)
          end
        end
    end
  end

  def presence_of_custom_fields
    inventory_category.inventory_category_custom_fields.each do |custom_field|
      errors.add(:base, "#{custom_field.label} cannot be blank") if custom_field.require && @input_custom_fields[custom_field.id.to_s].blank?
    end
  end
end
