class ChangeColumnName < ActiveRecord::Migration[6.1]
  def change
    rename_column :search_histories, :top_search_words, :top_search_word
    rename_column :search_histories, :top_visited_links, :top_visited_link
  end
end
