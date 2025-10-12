# frozen_string_literal: true

# 直近N日間でお気に入り（Favorite）が多い IncenseReview を返すクエリ
class RecommendedReviewsQuery
  # @param period [ActiveSupport::Duration] 例: 7.days
  # @param limit  [Integer] 例: 8
  # @return [ActiveRecord::Relation<IncenseReview>]
  def self.call(period:, limit:)
    period_start = Time.current - period

    # 期間内の「レビューごとのお気に入り数」と「最新お気に入り日時」を集計
    sub = Favorite
          .where("favorites.created_at >= ?", period_start)
          .group(:review_id)
          .select("review_id, COUNT(*) AS recent_fav_count, MAX(favorites.created_at) AS last_fav_at")

    # 集計サブクエリとレビューを結合し、件数→最新fav→レビュー作成日の順で降順にソート
    IncenseReview
      .joins("INNER JOIN (#{sub.to_sql}) rec ON rec.review_id = incense_reviews.id")
      .includes(:user, :tags, photo_attachment: :blob) # N+1対策
      .order("rec.recent_fav_count DESC, rec.last_fav_at DESC, incense_reviews.created_at DESC")
      .limit(limit)
  end
end
