class DropYoutubeChannels < ActiveRecord::Migration[6.1]
  def change
    drop_table :youtube_channels
  end
end
