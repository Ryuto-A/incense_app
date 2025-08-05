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
  
    if @comment.user == current_user # 自分のコメントのみ削除可能
      @comment.destroy
      respond_to do |format|
        format.turbo_stream
        format.html do
          flash[:success] = "コメントを削除しました。"
          redirect_back(fallback_location: incense_review_path(@comment.incense_review))
        end
      end
    else
      flash[:alert] = "削除権限がありません。"
      redirect_back(fallback_location: incense_review_path(@comment.incense_review))
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    authorize_comment_owner!
  end

  def update
    @comment = Comment.find(params[:id])
    authorize_comment_owner!
    if @comment.update(comment_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @comment.incense_review, notice: 'コメントを更新しました。' }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  private
  
  def authorize_comment_owner!
    unless @comment.user == current_user
      redirect_to root_path, alert: "編集権限がありません。"
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end

