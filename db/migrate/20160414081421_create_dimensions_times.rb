class CreateDimensionsTimes < ActiveRecord::Migration
  def change
    create_table :dimensions_times do |t|
      t.integer :minute_of_day
      t.integer :minute_of_hour
      t.integer :hour
      t.string :timezone
      t.string :day_part

      t.timestamps null: false
    end

    add_index :dimensions_times, :minute_of_day, unique: true
    add_index :dimensions_times, :hour
    add_index :dimensions_times, :day_part
  end
end
