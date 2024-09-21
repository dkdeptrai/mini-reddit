class CommentsController < ApplicationController

  include Authenticatable

  before_action :set_commentable, only: %i[new create show index]
  before_action :set_comment, only: %i[show]
  before_action :set_post
  before_action :check_owner, only: %i[destroy edit update], unless: :skip_action?

  def edit

  end

  def update
    if @comment.update(comment_params)
      redirect_to @comment.commentable, notice: 'Comment was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_to @comment.commentable, notice: 'Comment was successfully destroyed.'
  end

  def new
    @comment = @commentable.comments.new
  end

  def show
  end

  def create
    @comment = @commentable.comments.build(comment_params.merge(user_id: current_user.id))
    if @comment.save
      respond_to do |format|
        format.html { redirect_to @commentable, notice: 'Comment was successfully created.' }
        format.turbo_stream
      end
    else
      Rails.logger.debug("Error saving comment: #{@comment.errors.full_messages}")
      render @post, status: :unprocessable_entity, notice: 'Comment was not created.'
    end
  end

  def index

  end

  private

  def comment_params
    params.require(:comment).permit(:user_id, :commentable_id, :commentable_type, :body)
  end

  def set_post
    if @commentable.is_a? Comment
      @post = @commentable.root_commentable
    else
      @post = @commentable
    end
  end

  def check_owner
    unless @comment.user == current_user
      redirect_to @comment.commentable, notice: 'You are not the owner of this comment.'
    end
  end

  def set_comment
    @comment = Comment.find(params[:comment_id])
  end

  def set_commentable
    if params[:comment_id]
      @commentable = Comment.find(params[:comment_id])
    elsif params[:post_id]
      @commentable = Post.find(params[:post_id])
    elsif params[:id]
      if params[:controller] == 'posts'
        @commentable = Post.find(params[:id])
      elsif params[:controller] == 'comments'
        @commentable = Comment.find(params[:id])
      end
    else
      raise ActiveRecord::RecordNotFound, "Couldn't find a votable object"
    end
  end

end
