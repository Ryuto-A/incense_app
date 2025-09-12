class IncenseReview < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  enum scent_category: { sweet: 0, woody: 1, floral: 2 }

  has_one_attached :photo

  validates :title, presence: true
  validates :scent_category, presence: true
  validates :smoke_intensity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :content, presence: true

  # gem active_storage_validationsによる添付画像のバリデーション設定
  validates :photo,
  content_type: %w[image/png image/jpg image/jpeg image/webp],
  size: { less_than: 10.megabytes }
end
