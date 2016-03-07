class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.string :importer
      t.integer :inserted_records
      t.jsonb :log

      t.timestamps null: false
    end
  end
end
