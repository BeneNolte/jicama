class CreateSearchHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :search_histories do |t|
      t.text :top_search_words, array: true, default: []
      t.text :top_visited_links, array: true, default: []
      t.date :timestamp
      t.boolean :deleted, default: false
      t.references :datasource, null: false, foreign_key: true

      t.timestamps
    end
  end
end
