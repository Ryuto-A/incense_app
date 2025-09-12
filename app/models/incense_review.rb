class IncenseReview < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  # ↓ これを必ず入れる（非標準FK review_id を明示）
  has_many :review_tags, class_name: "ReviewTag", foreign_key: :review_id, dependent: :destroy
  has_many :tags, through: :review_tags

  enum scent_category: { sweet: 0, woody: 1, floral: 2 }, _prefix: true

  has_one_attached :photo

  validates :title, presence: true
  validates :scent_category, presence: true
  validates :smoke_intensity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :content, presence: true

  # gem active_storage_validationsによる添付画像のバリデーション設定
  validates :photo,
  content_type: %w[image/png image/jpg image/jpeg image/webp],
  size: { less_than: 10.megabytes }

  # === ここから検索用スコープ ===

  # キーワード: title/content/product_name を部分一致（ILIKE）
  scope :with_keyword, ->(q) {
    return all if q.blank?
    pattern = "%#{sanitize_sql_like(q)}%"
    where("title ILIKE :p OR content ILIKE :p OR product_name ILIKE :p", p: pattern)
  }

  # カテゴリ: enumのキー(sweet/woody/floral)の配列を受け取り
  scope :with_categories, ->(categories) {
    return all if categories.blank?
    where(scent_category: categories)
  }

  # 煙の強さ: 範囲指定
  scope :with_smoke_between, ->(min, max) {
    min = (min.presence || 1).to_i
    max = (max.presence || 5).to_i
    where(smoke_intensity: (min..max))
  }

  # タグ: いずれか一致
  scope :tagged_with_any, ->(ids) {
    return all if ids.blank?
    joins(:review_tags).where(review_tags: { tag_id: ids }).distinct
  }

  # タグ: すべて一致（選択タグ数以上の一致）
  scope :tagged_with_all, ->(ids) {
    return all if ids.blank?
    joins(:review_tags)
      .where(review_tags: { tag_id: ids })
      .group(:id)
      .having("COUNT(DISTINCT review_tags.tag_id) >= ?", ids.uniq.size)
  }

  # 画像あり
  scope :with_photo, -> {
    joins(:photo_attachment) # ActiveStorage has_one_attached :photo 前提
  }
end