class CreateVideos < ActiveRecord::Migration[7.2]
  def change
    create_table :videos do |t|
      t.string :title
      t.string :youtube_id
      t.string :url
      t.string :thumbnail_url
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :videos, :youtube_id, unique: true
  end
end
