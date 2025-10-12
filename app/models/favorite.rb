class Favorite < ApplicationRecord
  belongs_to :user, inverse_of: :favorites
  belongs_to :incense_review,
             class_name: "IncenseReview",
             foreign_key: :review_id,
             counter_cache: true,
             inverse_of: :favorites

  validates :review_id, uniqueness: { scope: :user_id }
end
