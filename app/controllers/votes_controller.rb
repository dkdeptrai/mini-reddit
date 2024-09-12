class VotesController < ApplicationController
  include ActionView::RecordIdentifier

  # before_action :authenticate_user!, only: %i[upvote downvote]
  before_action :check_signed_in
  before_action :find_post, unless: :skip_action?
  before_action :find_or_initialize_vote, unless: :skip_action?

  def upvote
    handle_vote('upvote')
  end

  def downvote
    handle_vote('downvote')
  end

  private

  def check_signed_in
    unless user_signed_in?
      Rails.logger.debug("About to redirect to sign in page")
      # respond_to do |format|
      #   format.html { redirect_to new_user_session_path, notice: 'You have to sign up or sign in before doing that action.' }
      #   format.turbo_stream do
      #     render turbo_stream: [
      #       turbo_stream.update("page", partial: "shared/full_page_redirect",
      #                           locals: { url: new_user_session_path })
      #     ]
      #   end
      # end
      redirect_to new_user_session_path, notice: 'You have to sign up or sign in before doing that action.'
      @skip_action = true
    end
  end

  def find_post
    @post = Post.find(params[:post_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def find_or_initialize_vote
    @vote = Vote.find_by(user_id: current_user.id, votable_id: @post.id, votable_type: 'Post') || Vote.new(user_id: current_user.id, votable_id: @post.id, votable_type: 'Post')
  end

  def handle_vote(vote_type)
    if @vote.vote_type == vote_type
      @vote.destroy!
    else
      @vote.destroy!
      @vote = Vote.new(user_id: current_user.id, votable_id: @post.id, votable_type: 'Post')
      @vote.vote_type = vote_type
      @vote.save!
    end
    @post.reload
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace(dom_id(@post), partial: 'posts/post', locals: { post: @post, user: current_user }) }
      format.html { redirect_to posts_path }
    end
  end

  # Only allow a list of trusted parameters through.
  def vote_params
    params.require(:vote).permit(:user_id, :votable_id, :votable_type, :vote_type)
  end

  def skip_action?
    @skip_action
  end
end
