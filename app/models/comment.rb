class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :incense_review

  validates :content, presence: true

  after_create_commit :notify_review_author

  private

  def notify_review_author
    CommentNotificationService.new(self).call
  end
end