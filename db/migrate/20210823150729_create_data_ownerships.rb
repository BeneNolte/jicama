class CreateDataOwnerships < ActiveRecord::Migration[6.1]
  def change
    create_table :data_ownerships do |t|
      t.references :company, null: false, foreign_key: true
      t.references :datasource, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
