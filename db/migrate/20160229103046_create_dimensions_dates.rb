class CreateDimensionsDates < ActiveRecord::Migration
  def change
    create_table :dimensions_dates do |t|
      t.string :date, null: false
      t.string :date_name, null: false
      t.string :date_name_abbreviated, null: false
      t.integer :year, null: false
      t.integer :quarter, null: false
      t.integer :month, null: false
      t.string :month_name, null: false
      t.string :month_name_abbreviated, null: false
      t.integer :week, null: false
      t.integer :day_of_year, null: false
      t.integer :day_of_quarter, null: false
      t.integer :day_of_month, null: false
      t.integer :day_of_week, null: false
      t.string :day_name, null: false
      t.string :day_name_abbreviated, null: false
      t.string :weekday_weekend, null: false

      t.timestamps null: false
    end

    add_index :dimensions_dates, :date, unique: true
    add_index :dimensions_dates, :date_name, unique: true
    add_index :dimensions_dates, :date_name_abbreviated, unique: true
  end
end
