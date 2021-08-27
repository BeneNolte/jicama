class CreateChromeSearchWords < ActiveRecord::Migration[6.1]
  def change
    create_table :chrome_search_words do |t|
      t.text :word
      t.integer :count
      t.string :time_range
      t.references :datasource, null: false, foreign_key: true

      t.timestamps
    end
  end
end
