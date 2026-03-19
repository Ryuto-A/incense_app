require "rails_helper"

RSpec.describe CommentNotifierMailer, type: :mailer do
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

  let(:comment) do
    Comment.create!(
      user: comment_user,
      incense_review: review,
      content: "テストコメント"
    )
  end

  let(:mail) { described_class.comment_created(comment) }

  it "正しい宛先に送信される" do
    expect(mail.to).to eq([review_user.email])
  end

  it "正しい件名である" do
    expect(mail.subject).to eq("【IncenseApp】あなたのレビューにコメントが付きました")
  end
end
