class CreateYoutubeChannels < ActiveRecord::Migration[6.1]
  def change
    create_table :youtube_channels do |t|
      t.string :channel_title
      t.string :url
      t.string :status
      t.references :datasource, null: false, foreign_key: true
      t.date :timestamp

      t.timestamps
    end
  end
end
