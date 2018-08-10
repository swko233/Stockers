class CreateBookmarks < ActiveRecord::Migration[5.2]
  def change
    create_table :bookmarks do |t|
      t.string :service_name, :null => false
      t.string :url, :null => false
      t.string :overview
      t.text :description
      t.string :service_image_id
      t.boolean :is_published, :default => true
      t.boolean :is_recommended, :default => false
      t.boolean :is_work, :default => false, :null => false
      t.integer :folder_id

      t.timestamps
    end
  end
end
