class CreateFactsBookings < ActiveRecord::Migration
  def change
    create_table :facts_bookings do |t|
      t.references :dimensions_date, index: true, foreign_key: true
      t.string :reference_number

      t.timestamps null: false
    end

    add_index :facts_bookings, :reference_number, unique: true
  end
end
