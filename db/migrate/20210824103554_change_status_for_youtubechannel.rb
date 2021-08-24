class ChangeStatusForYoutubechannel < ActiveRecord::Migration[6.1]
  def change
    change_column :youtube_channels, :status, :boolean, using: 'status::boolean'
  end
end
