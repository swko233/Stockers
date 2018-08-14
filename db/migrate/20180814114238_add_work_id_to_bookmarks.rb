class AddWorkIdToBookmarks < ActiveRecord::Migration[5.2]
  def change
    add_column :bookmarks, :work_id, :integer
  end
end
