class CommentsController < ApplicationController

  before_action :set_commentable

  def new
    @comment = @commentable.comments.new
  end

  def create
    @comment = @commentable.comments.build(comment_params)

    if @comment.save
      redirect_to @commentable, notice: 'Comment was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:user_id, :commentable_id, :commentable_type, :body)
  end

  def set_commentable
    if params[:post_id]
      @commentable = Post.find(params[:post_id])
    elsif params[:comment_id]
      @commentable = Comment.find(params[:comment_id])
    else
      Raise "Unsupportable commentable type"
    end
    Rails.logger.debug "Commentable: #{@commentable}"
  end

end
