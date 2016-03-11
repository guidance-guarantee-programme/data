class AddLeadTimeToBooking < ActiveRecord::Migration
  def change
    add_column :facts_bookings, :lead_time, :integer
  end
end
