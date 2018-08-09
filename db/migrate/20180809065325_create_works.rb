class CreateWorks < ActiveRecord::Migration[5.2]
  def change
    create_table :works do |t|
      t.string :service_name, :null => false
      t.string :url, :null => false
      t.date :release_date
      t.string :overview
      t.text :description
      t.string :service_image_id
      t.boolean :is_published, :default => true
      t.boolean :is_recommended, :default => false
      t.integer :user_id

      t.timestamps
    end
  end
end
