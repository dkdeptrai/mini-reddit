# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  body             :text
#  commentable_type :string           not null
#  votes_count      :integer          default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  commentable_id   :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_comments_on_commentable  (commentable_type,commentable_id)
#  index_comments_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  has_rich_text :body

  validates :body, presence: true
  validates :user_id, presence: true
  validates :commentable_id, presence: true
  validates :commentable_type, presence: true

  def root_commentable
    comment = self
    while comment.commentable.is_a? Comment
      comment = comment.commentable
    end

    comment.commentable
  end
end
