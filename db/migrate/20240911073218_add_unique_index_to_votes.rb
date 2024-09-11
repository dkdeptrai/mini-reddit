class AddUniqueIndexToVotes < ActiveRecord::Migration[7.1]
  def change
    add_index :votes, %i[ user_id post_id ], unique: true
  end

end
