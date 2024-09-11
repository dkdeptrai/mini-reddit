class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :post

  enum vote_type: { upvote: 0, downvote: 1 }

  after_create :update_votes_count_after_create
  before_destroy :update_votes_count_before_destroy
  validates :user_id, uniqueness: { scope: :post_id }

  private

  def increment_post_votes_count
    post.increment!(:votes_count)

  end

  def decrement_post_votes_count
    post.decrement!(:votes_count)
  end

  def update_votes_count_after_create
    if upvote?
      increment_post_votes_count
    elsif downvote?
      decrement_post_votes_count
    end
    broadcast_vote
  end

  def update_votes_count_before_destroy
    if upvote?
      decrement_post_votes_count
    elsif downvote?
      increment_post_votes_count
    end
    broadcast_vote
  end

  def broadcast_vote
    broadcast_replace_to('posts', target: "post_#{post.id}", partial: 'posts/post', locals: { post: post, user: user })
  end
end
