class CreateChromeVisitedLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :chrome_visited_links do |t|
      t.string :link
      t.integer :count
      t.string :time_range
      t.references :datasource, null: false, foreign_key: true

      t.timestamps
    end
  end
end
