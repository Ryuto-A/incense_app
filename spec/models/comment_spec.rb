require "rails_helper"

RSpec.describe Comment, type: :model do
  describe "after_create_commit" do
    include ActiveJob::TestHelper

    let(:review_user) do
      User.create!(
        name: "レビュー投稿者",
        email: "reviewer@example.com",
        password: "password"
      )
    end

    let(:comment_user) do
      User.create!(
        name: "コメント投稿者",
        email: "commenter@example.com",
        password: "password"
      )
    end

    let(:review) do
      IncenseReview.create!(
        user: review_user,
        title: "テストレビュー",
        scent_category: :sweet,
        smoke_intensity: 3,
        content: "レビュー本文"
      )
    end

    before do
      ActiveJob::Base.queue_adapter = :test
      clear_enqueued_jobs
      clear_performed_jobs
    end

    after do
      clear_enqueued_jobs
      clear_performed_jobs
    end

    it "別ユーザーのコメント作成時に通知メールがenqueueされる" do
      expect do
        Comment.create!(
          user: comment_user,
          incense_review: review,
          content: "これはテストコメントです"
        )
      end.to have_enqueued_mail(CommentNotifierMailer, :comment_created)
    end

    it "自分の投稿に自分でコメントした場合は通知メールがenqueueされない" do
      expect do
        Comment.create!(
          user: review_user,
          incense_review: review,
          content: "自分でコメント"
        )
      end.not_to have_enqueued_mail(CommentNotifierMailer, :comment_created)
    end
  end
end