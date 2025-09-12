class ReviewTag < ApplicationRecord
  belongs_to :incense_review, class_name: "IncenseReview", foreign_key: :review_id
  belongs_to :tag
  validates  :review_id, uniqueness: { scope: :tag_id }
end
