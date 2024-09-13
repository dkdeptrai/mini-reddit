class CommentsController < ApplicationController

  def new
    @comment = Comment.new
  end



  private

  def comment_params
    params.require(:comment).permit(:user_id, :commentable_id, :commentable_type, :body)
  end
end
