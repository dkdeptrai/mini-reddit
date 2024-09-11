class ChangeVoteColumnsNameFromTypeToVoteType < ActiveRecord::Migration[7.1]
  def change
    rename_column :votes, :type, :vote_type
  end
end
