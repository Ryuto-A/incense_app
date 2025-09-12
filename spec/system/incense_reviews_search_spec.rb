require "rails_helper"

RSpec.describe "IncenseReviews search", type: :system, js: true do
  let!(:user)  { create(:user) }
  let!(:sweet) { create(:incense_review, title: "Sweet tone", scent_category: :sweet, smoke_intensity: 2) }
  let!(:woody) { create(:incense_review, title: "Woody tone", scent_category: :woody, smoke_intensity: 4) }

  it "キーワードで絞り込みできる" do
    visit incense_reviews_path

    fill_in "キーワード", with: "Woody"
    click_button "検索"  # ← フォーム送信を明示

    # 1) まず差し替え完了をフレーム外から待つ
    expect(page).to have_selector("turbo-frame#reviews", text: "1 件ヒット")

    # 2) その後に within で検証（古いノード参照を避ける）
    within("turbo-frame#reviews") do
      expect(page).to have_content("Woody tone")
      expect(page).to have_no_content("Sweet tone")  # ← 待機付きの否定
    end
  end

  it "カテゴリで絞り込みできる（複数選択可）" do
    visit incense_reviews_path

    select "Sweet", from: "香りカテゴリ（複数可）"
    click_button "検索"

    expect(page).to have_selector("turbo-frame#reviews", text: "1 件ヒット")

    within("turbo-frame#reviews") do
      expect(page).to have_content("Sweet tone")
      expect(page).to have_no_content("Woody tone")
    end
  end
end
