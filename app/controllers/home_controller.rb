class HomeController < ApplicationController
  def index
    # --- おすすめ投稿：直近7日 × お気に入り数順 ---
    @recommend_period = 7.days
    @recommended_reviews = RecommendedReviewsQuery.call(period: @recommend_period, limit: 8)

    # フラグメントキャッシュ用キー（期間 + 期間内のFavoritesの最終更新時刻）
    period_start = Time.current - @recommend_period
    @recommend_cache_sig =
      Favorite.where("created_at >= ?", period_start).maximum(:updated_at)&.to_i # nil もあり得る
  end
end
