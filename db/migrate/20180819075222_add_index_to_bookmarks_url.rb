class AddIndexToBookmarksUrl < ActiveRecord::Migration[5.2]
  def change
  	add_index :bookmarks, [:url, :user_id], unique: true
  end
end
