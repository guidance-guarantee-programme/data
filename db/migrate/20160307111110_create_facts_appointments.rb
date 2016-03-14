class CreateFactsAppointments < ActiveRecord::Migration
  def change
    create_table :facts_appointments do |t|
      t.references :dimensions_date, index: true, foreign_key: true
      t.string :reference_number
      t.string :reference_updated_at

      t.timestamps null: false
    end

    add_index :facts_appointments, :reference_number, unique: true
  end
end
