class CreateFolders < ActiveRecord::Migration[5.2]
  def change
    create_table :folders do |t|
      t.string :folder_name
      t.boolean :is_published, :default => true
      t.integer :user_id

      t.timestamps
    end
  end
end
