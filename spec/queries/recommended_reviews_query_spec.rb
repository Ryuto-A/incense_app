# frozen_string_literal: true

require "rails_helper"

RSpec.describe RecommendedReviewsQuery, type: :model do
  let(:owner) { User.create!(email: "o@example.com", password: "password") }
  let(:u1)    { User.create!(email: "u1@example.com", password: "password") }
  let(:u2)    { User.create!(email: "u2@example.com", password: "password") }

  let!(:r1) do
    IncenseReview.create!(user: owner, title: "R1", scent_category: :sweet, smoke_intensity: 3, content: "c")
  end
  let!(:r2) do
    IncenseReview.create!(user: owner, title: "R2", scent_category: :sweet, smoke_intensity: 3, content: "c")
  end
  let!(:r3_old) do
    IncenseReview.create!(user: owner, title: "Old", scent_category: :sweet, smoke_intensity: 3, content: "c")
  end

  it "returns reviews ordered by favorites in recent period (desc), excluding old favorites" do
    travel_to Time.zone.parse("2025-10-01 12:00")

    # 直近7日内のfav
    Favorite.create!(user: u1, incense_review: r1, created_at: 2.days.ago)
    Favorite.create!(user: u2, incense_review: r1, created_at: 1.day.ago)

    Favorite.create!(user: u1, incense_review: r2, created_at: 3.days.ago)

    # 期間外（8日前）は集計対象外
    Favorite.create!(user: u1, incense_review: r3_old, created_at: 8.days.ago)

    results = described_class.call(period: 7.days, limit: 10).to_a
    expect(results).to eq([r1, r2]) # r1:2件, r2:1件, r3_old:0件(期間外)
  end

  it "breaks tie by last_fav_at then review created_at" do
    travel_to Time.zone.parse("2025-10-01 12:00")

    # r1 と r2 を1件ずつにして、より“最近”付いた方が上に来るか
    Favorite.create!(user: u1, incense_review: r1, created_at: 3.days.ago)
    Favorite.create!(user: u1, incense_review: r2, created_at: 1.day.ago)

    results = described_class.call(period: 7.days, limit: 10).to_a
    expect(results.first).to eq(r2)
  end
end
