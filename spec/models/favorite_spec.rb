# frozen_string_literal: true

require "rails_helper"

RSpec.describe Favorite, type: :model do
  let(:user)   { User.create!(email: "u@example.com", password: "password") }
  let(:owner)  { User.create!(email: "o@example.com", password: "password") }
  let(:review) do
    IncenseReview.create!(
      user: owner,
      title: "香りテスト",
      scent_category: :sweet,
      smoke_intensity: 3,
      content: "content"
    )
  end

  it "is valid with user and review" do
    fav = described_class.new(user: user, incense_review: review)
    expect(fav).to be_valid
  end

  it "validates uniqueness of [user_id, review_id]" do
    described_class.create!(user: user, incense_review: review)
    dup = described_class.new(user: user, incense_review: review)
    expect(dup).not_to be_valid
    # 国際化対応：文言ではなく :taken を検証
    expect(dup.errors.details[:review_id]).to include(a_hash_including(error: :taken))
  end

  it "increments/decrements counter_cache" do
    expect(review.favorites_count).to eq(0)
    fav = nil
    expect do
      fav = described_class.create!(user: user, incense_review: review)
    end.to change { review.reload.favorites_count }.by(1)
    expect do
      fav.destroy!
    end.to change { review.reload.favorites_count }.by(-1)
  end
end
