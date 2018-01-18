class ReportCategory < ApplicationRecord
  has_many :report_details, dependent: :destroy
  belongs_to :organization

  enum status: {obligatory: 1, optional: 2}

  scope :order_desc, ->{order created_at: :desc}

  validates :name, presence: true, length: {maximum: Settings.max_name_category},
    uniqueness: {scope: :organization_id}
end