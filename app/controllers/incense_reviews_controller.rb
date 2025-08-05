class IncenseReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_incense_review, only: [:show, :edit, :update, :destroy]

  def index
    @incense_reviews = IncenseReview.all.order(created_at: :desc)
  end

  def show
    @comments = @incense_review.comments.includes(:user)
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
    params.require(:incense_review).permit(:title, :scent_category, :smoke_intensity, :content, :product_url, :product_name, :product_image)
  end
end
