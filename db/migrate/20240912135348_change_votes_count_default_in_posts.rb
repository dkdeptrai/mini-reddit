class ChangeVotesCountDefaultInPosts < ActiveRecord::Migration[7.1]
  def change
    change_column_default :posts, :votes_count, from: nil, to: 0
  end
end
