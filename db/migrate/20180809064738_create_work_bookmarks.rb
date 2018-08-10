class CreateWorkBookmarks < ActiveRecord::Migration[5.2]
  def change
    create_table :work_bookmarks do |t|
      t.boolean :is_published, :default => true
      t.boolean :is_recommended, :default => false
      t.boolean :is_work, :default => true, :null => false
      t.integer :user_id
      t.integer :work_id
      t.integer :folder_id

      t.timestamps
    end
  end
end
