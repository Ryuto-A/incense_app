# frozen_string_literal: true

require "rails_helper"

RSpec.describe RecommendedReviewsQuery, type: :model do
  around do |example|
    travel_to(Time.zone.parse("2025-10-01 12:00")) { example.run }
  end

  let(:owner) { User.create!(email: "o@example.com", password: "password") }
  let(:users) do
    [
      User.create!(email: "user_a@example.com", password: "password"),
      User.create!(email: "user_b@example.com", password: "password")
    ]
  end

  let!(:review_one) do
    IncenseReview.create!(user: owner, title: "R1", scent_category: :sweet, smoke_intensity: 3, content: "c")
  end
  let!(:review_two) do
    IncenseReview.create!(user: owner, title: "R2", scent_category: :sweet, smoke_intensity: 3, content: "c")
  end
  let!(:old_review) do
    IncenseReview.create!(user: owner, title: "Old", scent_category: :sweet, smoke_intensity: 3, content: "c")
  end

  it "returns reviews ordered by favorites in recent period (desc), excluding old favorites" do
    # 直近7日内のfav（基準時刻 2025-10-01 12:00 からの相対）
    Favorite.create!(user: users[0], incense_review: review_one, created_at: 2.days.ago)
    Favorite.create!(user: users[1], incense_review: review_one, created_at: 1.day.ago)
    Favorite.create!(user: users[0], incense_review: review_two, created_at: 3.days.ago)

    # 期間外（8日前）
    Favorite.create!(user: users[0], incense_review: old_review, created_at: 8.days.ago)

    results = described_class.call(period: 7.days, limit: 10).to_a
    expect(results).to eq([review_one, review_two])
  end

  it "breaks tie by last_fav_at then review created_at" do
    Favorite.create!(user: users[0], incense_review: review_one, created_at: 3.days.ago)
    Favorite.create!(user: users[0], incense_review: review_two, created_at: 1.day.ago)

    results = described_class.call(period: 7.days, limit: 10).to_a
    expect(results.first).to eq(review_two)
  end
end
