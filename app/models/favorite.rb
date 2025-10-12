class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :incense_review, class_name: "IncenseReview", foreign_key: :review_id, counter_cache: true

  validates :user_id, presence: true
  validates :review_id, presence: true
  validates :review_id, uniqueness: { scope: :user_id }
end
