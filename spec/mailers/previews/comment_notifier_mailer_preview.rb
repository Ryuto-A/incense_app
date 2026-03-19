# Preview all emails at http://localhost:3000/rails/mailers/comment_notifier_mailer
class CommentNotifierMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/comment_notifier_mailer/comment_created
  def comment_created
    CommentNotifierMailer.comment_created
  end

end
