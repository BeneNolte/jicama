class DropYoutubeHistoriesTable < ActiveRecord::Migration[6.1]
  def change
    drop_table :youtube_histories
  end
end
