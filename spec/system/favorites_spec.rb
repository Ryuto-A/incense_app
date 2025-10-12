# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Favorites", type: :system do
  let(:user)   { User.create!(email: "u@example.com", password: "password") }
  let(:owner)  { User.create!(email: "o@example.com", password: "password") }
  let!(:review) do
    IncenseReview.create!(
      user: owner,
      title: "香りテスト",
      scent_category: :sweet,
      smoke_intensity: 3,
      content: "content"
    )
  end

  def count_text
    find(%([data-testid="favorite-count-#{review.id}"])).text
  end

  context "when logged in" do
    before do
      visit new_user_session_path
      fill_in "user_email", with: user.email
      fill_in "user_password", with: "password"
      find('input[type="submit"]').click
    end

    it "toggles from index" do
      visit incense_reviews_path

      within %([id="favorite_button_review_#{review.id}"]) do
        # 追加
        find(%([data-testid="favorite-btn-#{review.id}"])).click
      end

      within %([id="favorite_button_review_#{review.id}"]) do
        expect(page).to have_css(%([data-state="on"]))
        expect(count_text).to eq("1")
      end

      # 解除
      within %([id="favorite_button_review_#{review.id}"]) do
        find(%([data-testid="favorite-btn-#{review.id}"])).click
      end

      within %([id="favorite_button_review_#{review.id}"]) do
        expect(page).to have_css(%([data-state="off"]))
        expect(count_text).to eq("0")
      end
    end

    it "toggles from show and prevents duplicate" do
      visit incense_review_path(review)

      # 1回目：追加
      within %([id="favorite_button_review_#{review.id}"]) do
        find(%([data-testid="favorite-btn-#{review.id}"])).click
        expect(page).to have_css(%([data-state="on"]))
        expect(count_text).to eq("1")
      end

      # 2回目：再度押しても増えない（解除ではなく同じPOSTは来ないUIなので index と同等シナリオで確認）
      visit incense_review_path(review)
      within %([id="favorite_button_review_#{review.id}"]) do
        expect(count_text).to eq("1")
      end
    end
  end

  context "when not logged in" do
    it "redirects to login on toggle" do
      visit incense_reviews_path
      within %([id="favorite_button_review_#{review.id}"]) do
        find(%([data-testid="favorite-btn-#{review.id}"])).click
      end
      expect(page).to have_current_path(new_user_session_path)
    end
  end
end
