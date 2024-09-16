class VotesController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :check_signed_in
  before_action :find_votable, unless: :skip_action?
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
      redirect_to new_user_session_path, notice: 'You have to sign up or sign in before doing that action.'
      @skip_action = true
    end
  end

  def find_votable
    Rails.logger.debug("Params: #{params.inspect}")

    if params[:comment_id]
      @votable = Comment.find(params[:comment_id])
      Rails.logger.debug("Found comment: #{@votable.id}")
    elsif params[:post_id]
      @votable = Post.find(params[:post_id])
      Rails.logger.debug("Found post: #{@votable.id}")
    elsif params[:id]
      if params[:controller] == 'posts'
        @votable = Post.find(params[:id])
        Rails.logger.debug("Found post from id: #{@votable.id}")
      else
        @votable = Comment.find(params[:id])
        Rails.logger.debug("Found comment from id: #{@votable.id}")
      end
    else
      raise ActiveRecord::RecordNotFound, "Couldn't find a votable object"
    end

    Rails.logger.debug("Votable: #{@votable.class.name} with ID: #{@votable.id}")
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

  def skip_action?
    @skip_action
  end
end
