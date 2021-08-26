class CreateYoutubeHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :youtube_histories do |t|
      t.text :top_video_title
      t.text :top_channel_name
      t.date :timestamp
      t.boolean :deleted
      t.references :datasource, null: false, foreign_key: true

      t.timestamps
    end
  end
end
