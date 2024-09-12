# == Schema Information
#
# Table name: posts
#
#  id          :bigint           not null, primary key
#  content     :string
#  title       :string
#  votes_count :integer          default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord
  belongs_to :user
  has_many :votes, as: :votable, dependent: :destroy
end

