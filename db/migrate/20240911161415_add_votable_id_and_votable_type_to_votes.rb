class AddVotableIdAndVotableTypeToVotes < ActiveRecord::Migration[7.1]
  def change
    change_table :votes do |t|
      t.references :votable, polymorphic: true, null: false
    end
    remove_column :votes, :post_id
  end
end
