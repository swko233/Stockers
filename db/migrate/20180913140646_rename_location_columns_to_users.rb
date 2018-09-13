class RenameLocationColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
  	rename_column :users, :location, :twitter_image_url
  end
end
