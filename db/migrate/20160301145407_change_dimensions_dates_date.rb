class ChangeDimensionsDatesDate < ActiveRecord::Migration
  def change
    change_column :dimensions_dates, :date, 'date USING date::date'
  end
end
