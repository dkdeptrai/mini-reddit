class VotesController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :find_post
  before_action :find_or_initialize_vote

  def upvote
    handle_vote('upvote')
  end

  def downvote
    handle_vote('downvote')
  end

  private

  def find_post
    @post = Post.find(params[:post_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def find_or_initialize_vote
    @vote = Vote.find_by(user_id: current_user.id, post_id: @post.id) || Vote.new(user_id: current_user.id, post_id: @post.id)
  end

  def handle_vote(vote_type)
    Rails.logger.debug "Before vote: #{@post.votes.count}"
    if @vote.vote_type == vote_type
      @vote.destroy!
    else
      @vote.destroy!
      @vote = Vote.new(user_id: current_user.id, post_id: @post.id)
      @vote.vote_type = vote_type
      @vote.save!
    end
    Rails.logger.debug "After vote: #{@post.votes.count}"
    @post.reload
    Rails.logger.debug "After reload: #{@post.votes.count}"
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace(dom_id(@post), partial: 'posts/post', locals: { post: @post, user: current_user }) }
      format.html { redirect_to posts_path }
    end
  end

  # Only allow a list of trusted parameters through.
  def vote_params
    params.require(:vote).permit(:user_id, :post_id, :vote_type)
  end

end
