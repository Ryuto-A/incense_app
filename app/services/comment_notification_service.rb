class CommentNotificationService
  def initialize(comment)
    @comment = comment
    @review = comment.incense_review
    @review_author = @review.user
  end

  def call
    return unless review_author_notifiable?

    send_comment_notification_email
  end

  private

  attr_reader :comment, :review, :review_author

  def review_author_notifiable?
    return false if comment.user == review_author
    return false if review_author.email.blank?
    return false if review_author.email.end_with?("@example.invalid")

    true
  end

  def send_comment_notification_email
    CommentNotifierMailer.comment_created(comment).deliver_later
  end
end
