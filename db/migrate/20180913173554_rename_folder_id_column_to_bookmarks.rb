class RenameFolderIdColumnToBookmarks < ActiveRecord::Migration[5.2]
  def change
  	rename_column :bookmarks, :folder_id, :developer_id
  end
end
