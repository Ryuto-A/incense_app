class IncenseReview < ApplicationRecord
  belongs_to :user

  enum scent_category: { sweet: 0, woody: 1, floral: 2 }

  validates :title, presence: true
  validates :scent_category, presence: true
  validates :smoke_intensity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :content, presence: true
end
