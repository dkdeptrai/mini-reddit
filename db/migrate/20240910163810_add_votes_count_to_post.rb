class AddVotesCountToPost < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :votes_count, :integer
  end
end
