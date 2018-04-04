class Form < SoftDeleteBaseModel

  # Associations
  has_many :steps
  has_many :form_fields
  has_many :form_values

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :is_template, presence: true
end
