class CreateFactsCalls < ActiveRecord::Migration
  def change
    create_table :facts_calls do |t|
      t.references :dimensions_audit, index: true, foreign_key: true
      t.references :dimensions_date, index: true, foreign_key: true
      t.references :dimensions_time, index: true, foreign_key: true
      t.references :dimensions_outcome, index: true, foreign_key: true
      t.integer :call_time
      t.integer :talk_time
      t.integer :ring_time
      t.float :cost
      t.string :reference_number

      t.timestamps null: false
    end
  end
end
