class CommentNotifierMailer < ApplicationMailer
  def comment_created(comment)
    @comment = comment
    @review = comment.incense_review
    @review_user = @review.user
    @comment_user = comment.user

    mail(to: @review_user.email)
  end
end
