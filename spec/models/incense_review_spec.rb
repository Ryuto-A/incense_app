require "rails_helper"

RSpec.describe IncenseReview, type: :model do
  let!(:r1) { create(:incense_review, title: "Sweet wood", product_name: "A", scent_category: :sweet, smoke_intensity: 2) }
  let!(:r2) { create(:incense_review, title: "Woody rose",  product_name: "B", scent_category: :woody, smoke_intensity: 4) }

  describe ".with_keyword" do
    it "部分一致でヒット" do
      expect(IncenseReview.with_keyword("wood")).to match_array([r1, r2])
      expect(IncenseReview.with_keyword("rose")).to match_array([r2])
      expect(IncenseReview.with_keyword(nil)).to include(r1, r2)
    end
  end

  describe ".with_categories" do
    it "enumキー配列で絞り込み" do
      expect(IncenseReview.with_categories(%w[sweet])).to match_array([r1])
      expect(IncenseReview.with_categories([])).to include(r1, r2)
    end
  end

  describe ".with_smoke_between" do
    it "範囲で絞り込み" do
      expect(IncenseReview.with_smoke_between(3, 5)).to match_array([r2])
      expect(IncenseReview.with_smoke_between(nil, nil)).to include(r1, r2)
    end
  end

  context "tags" do
    let!(:t1) { create(:tag, name: "calm") }
    let!(:t2) { create(:tag, name: "night") }
    before do
      ReviewTag.create!(review_id: r1.id, tag: t1)
      ReviewTag.create!(review_id: r2.id, tag: t1)
      ReviewTag.create!(review_id: r2.id, tag: t2)
    end

    it ".tagged_with_any" do
      expect(IncenseReview.tagged_with_any([t2.id])).to match_array([r2])
    end

    it ".tagged_with_all" do
      expect(IncenseReview.tagged_with_all([t1.id, t2.id])).to match_array([r2])
    end
  end
end
