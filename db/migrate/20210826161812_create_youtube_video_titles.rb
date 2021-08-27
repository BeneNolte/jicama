class CreateYoutubeVideoTitles < ActiveRecord::Migration[6.1]
  def change
    create_table :youtube_video_titles do |t|
      t.text :title
      t.integer :count
      t.string :url
      t.string :time_range
      t.references :datasource, null: false, foreign_key: true

      t.timestamps
    end
  end
end
