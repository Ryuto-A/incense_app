class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :incense_review

  validates :content, presence: true
end

