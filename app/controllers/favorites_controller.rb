# frozen_string_literal: true

class FavoritesController < ApplicationController
  before_action :store_return_to_for_guest, only: [:create, :destroy]
  before_action :authenticate_user!
  before_action :set_review, only: :create

  # POST /incense_reviews/:incense_review_id/favorites
  def create
    favorite = current_user.favorites.find_or_initialize_by(review_id: @review.id)
    favorite.save unless favorite.persisted?
    @review.reload

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          dom_id_for_button(@review),
          partial: "incense_reviews/favorite_button",
          locals: {
            review: @review,
            favorited: true,
            favorite_id: favorite.id
          }
        )
      end
      format.html { redirect_back fallback_location: incense_review_path(@review), notice: t(".ok") }
    end
  end

  # DELETE /favorites/:id
  def destroy
    favorite = current_user.favorites.find_by(id: params[:id])
    @review = favorite&.incense_review || IncenseReview.find(params[:incense_review_id])
    favorite&.destroy
    @review.reload

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          dom_id_for_button(@review),
          partial: "incense_reviews/favorite_button",
          locals: {
            review: @review,
            favorited: false,
            favorite_id: nil
          }
        )
      end
      format.html { redirect_back fallback_location: incense_review_path(@review), notice: t(".ok") }
    end
  end

  private

  # 未ログインでお気に入りボタンを押したとき、ログイン後に元のページへ戻す
  def store_return_to_for_guest
    return if user_signed_in?

    # 可能なら直前のページ、なければ該当レビューの詳細
    back = request.referer.presence || incense_review_path(params[:incense_review_id] || params[:id])
    store_location_for(:user, back)
  end

  def set_review
    @review = IncenseReview.find(params[:incense_review_id])
  end

  # 例: "favorite_button_review_42"
  def dom_id_for_button(review)
    "favorite_button_review_#{review.id}"
  end
end
