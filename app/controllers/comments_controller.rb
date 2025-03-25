class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @incense_review = IncenseReview.find(params[:incense_review_id])
    @comment = @incense_review.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @incense_review, notice: "コメントを投稿しました。"
    else
      redirect_to @incense_review, alert: "コメントの投稿に失敗しました。"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.user == current_user
      @comment.destroy
      redirect_to @comment.incense_review, notice: "コメントを削除しました。"
    else
      redirect_to @comment.incense_review, alert: "削除権限がありません。"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end

