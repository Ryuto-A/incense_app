class IncenseReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_incense_review, only: [:show, :edit, :update, :destroy]

  def index
    @all_tags = Tag.order(:name)
  
    base = IncenseReview
             .includes(:user, :tags, photo_attachment: :blob)
             .order(created_at: :desc)
  
    q          = params[:q]
    categories = Array(params[:categories]).reject(&:blank?) & IncenseReview.scent_categories.keys
    smoke_min  = params[:smoke_min]
    smoke_max  = params[:smoke_max]
    tag_ids    = Array(params[:tag_ids]).reject(&:blank?).map(&:to_i) # map!からmapにして副作用が無い

    tag_match  = params[:tag_match] # "any" | "all"
    has_photo  = params[:has_photo].present?
  
    @incense_reviews = base
    @incense_reviews = @incense_reviews.with_keyword(q)
                                       .with_categories(categories)
                                       .with_smoke_between(smoke_min, smoke_max)
  
    if tag_ids.present?
      @incense_reviews = (tag_match == "all") ?
        @incense_reviews.tagged_with_all(tag_ids) :
        @incense_reviews.tagged_with_any(tag_ids)
    end
  
    @incense_reviews = @incense_reviews.with_photo if has_photo

    # N+1回避：ログイン時のみ「自分がお気に入り済みの review_id => favorite_id」のマップを事前計算
    if user_signed_in?
      ids = @incense_reviews.map(&:id) # そのままmapでOK（最小差分）。効率重視なら pluck(:id) でも可
      @favorites_map = current_user.favorites.where(review_id: ids).pluck(:review_id, :id).to_h
    end
  end

  def show
    @comments = @incense_review.comments.includes(:user)
      if user_signed_in?
        @my_fav_id = current_user.favorites.find_by(review_id: @incense_review.id)&.id
      end
  end

  def new
    @incense_review = IncenseReview.new
  end

  def create
    @incense_review = current_user.incense_reviews.build(incense_review_params)
    if @incense_review.save
      redirect_to @incense_review, notice: "レビューを投稿しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @incense_review.update(incense_review_params)
      redirect_to @incense_review, notice: "レビューを更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @incense_review.destroy
    redirect_to incense_reviews_path, notice: "レビューを削除しました。"
  end

  private

  def set_incense_review
    @incense_review = IncenseReview.find(params[:id])
  end

  def incense_review_params
    params.require(:incense_review).permit(
      :title, :scent_category, :smoke_intensity, :content,
      :product_url, :product_name, :product_image,
      :photo
    )
  end
end
