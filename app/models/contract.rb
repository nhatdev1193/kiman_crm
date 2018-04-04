class Contract < SoftDeleteBaseModel
  # Associations
  belongs_to :person
  has_many :people_steps
  has_many :steps, through: :people_steps

  # Callbacks
  after_initialize :set_default_status

  # Enum & constants
  enum status: {
    'Mới': 0, 'Chờ thẩm': 1, 'Đang thẩm': 2, 'Cần xác minh': 3,
    'Từ chối': 4, 'KH hủy': 5, 'Chờ duyệt hạn mức': 6, 'Chờ kí HĐ': 7,
    'Chờ giải ngân': 8, 'Thu nợ': 9, 'Nợ xấu': 10, 'Tất toán': 11
  }

  # Validations methods
  validates :person_id, presence: true

  def tele_evaluate
    people_steps.joins(:step).order(created_at: :desc).find_by("steps.field_name = 'tele_evaluate'")
  end

  def reference_evaluate
    people_steps.joins(:step).order(created_at: :desc).find_by("steps.field_name = 'reference_evaluate'")
  end

  def business_evaluate
    people_steps.joins(:step).order(created_at: :desc).find_by("steps.field_name = 'business_evaluate'")
  end

  def property_evaluate
    people_steps.joins(:step).order(created_at: :desc).find_by("steps.field_name = 'property_evaluate'")
  end

  private

  def set_default_status
    self.status = 0 if new_record?
  end
end
