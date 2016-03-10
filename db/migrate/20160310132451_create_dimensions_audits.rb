class CreateDimensionsAudits < ActiveRecord::Migration
  def change
    create_table :dimensions_audits do |t|
      t.string :fact_table, null: false
      t.string :source, null: false
      t.string :source_type, null: false
      t.integer :inserted_records, default: 0
      t.jsonb :log

      t.timestamps null: false
    end

    add_reference :facts_bookings, :dimensions_audit
  end
end
