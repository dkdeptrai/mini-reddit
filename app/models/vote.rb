# == Schema Information
#
# Table name: votes
#
#  id           :bigint           not null, primary key
#  votable_type :string           not null
#  vote_type    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#  votable_id   :bigint           not null
#
# Indexes
#
#  index_votes_on_user_id  (user_id)
#  index_votes_on_votable  (votable_type,votable_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  enum vote_type: { upvote: 0, downvote: 1 }

  after_create :update_votes_count_after_create
  before_destroy :update_votes_count_before_destroy
  validates :user_id, uniqueness: { scope: %i[votable_id votable_type] }

  private

  def increment_post_votes_count
    votable.increment!(:votes_count)

  end

  def decrement_post_votes_count
    votable.decrement!(:votes_count)
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
    if votable_type == 'Post'
      broadcast_replace_to('posts', target: "post_#{votable.id}", partial: 'posts/post', locals: { post: votable })
      Rails.logger.debug("Broadcasting vote to post_#{votable.id}")
    elsif votable_type == 'Comment'
      broadcast_replace_to('comments', target: "content_comment_#{votable.id}", partial: 'comments/comment_content', locals: { comment: votable })
      Rails.logger.debug("Broadcasting vote to content_comment_#{votable.id}")
    end

    # broadcast_replace_to('posts', target: "post_#{votable.id}", partial: 'posts/post', locals: { post: votable, user: user }) if votable_type == 'Post'
    # broadcast_replace_to('comments', target: "content_comment#{votable.id}", partial: 'comments/comment_content', locals: { comment: votable, user: user }) if votable_type == 'Comment'

  end
end
