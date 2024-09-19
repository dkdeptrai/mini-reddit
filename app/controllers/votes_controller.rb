class VotesController < ApplicationController
  include ActionView::RecordIdentifier
  include Authenticatable

  before_action :find_votable, unless: :skip_action?
  before_action :find_or_initialize_vote, unless: :skip_action?

  def upvote
    handle_vote('upvote')
  end

  def downvote
    handle_vote('downvote')
  end

  private

  def find_votable
    if params[:comment_id]
      @votable = Comment.find(params[:comment_id])
    elsif params[:post_id]
      @votable = Post.find(params[:post_id])
    elsif params[:id]
      if params[:controller] == 'posts'
        @votable = Post.find(params[:id])
      elsif params[:controller] == 'comments'
        @votable = Comment.find(params[:id])
      end
    else
      raise ActiveRecord::RecordNotFound, "Couldn't find a votable object"
    end
  end
  # Use callbacks to share common setup or constraints between actions.
  def find_or_initialize_vote
    @vote = Vote.find_by(user_id: current_user.id, votable_id: @votable.id, votable_type: @votable.class.name) || Vote.new(user_id: current_user.id, votable_id: @votable.id, votable_type: @votable.class.name)
  end

  def handle_vote(vote_type)
    if @vote.vote_type == vote_type
      @vote.destroy!
    else
      @vote.destroy!
      find_or_initialize_vote
      @vote.vote_type = vote_type
      @vote.save!
    end
    @votable.reload
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to posts_path }
    end
  end

  # Only allow a list of trusted parameters through.
  def vote_params
    params.require(:vote).permit(:user_id, :post_id, :comment_id, :vote_type)
  end
end
