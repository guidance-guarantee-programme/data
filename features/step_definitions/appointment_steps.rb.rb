Given(/^we import booking bug appointment data between "([^"]*)" and "([^"]*)"$/) do |begin_date, end_date|
  begin_date = Date.parse(begin_date)
  end_date = Date.parse(end_date)

  PopulateDateDimension.new(begin_date: begin_date, end_date: end_date).call

  @results = Providers::BookingBug::Appointments.new.call
end

When(/^I query appointments by state between "([^"]*)" and "([^"]*)"$/) do |begin_date, end_date|
  begin_date = Date.parse(begin_date)
  end_date = Date.parse(end_date)

  sql = <<-SQL
  SELECT dimensions_states.name, COUNT(*) AS appointments
  FROM facts_appointments
  INNER JOIN dimensions_dates ON (facts_appointments.dimensions_date_id = dimensions_dates.id)
  INNER JOIN dimensions_states ON (facts_appointments.dimensions_state_id = dimensions_states.id)
  WHERE dimensions_dates.date BETWEEN ? AND ?
  GROUP BY dimensions_states.name
  SQL

  @count_by_state = Facts::Appointment.find_by_sql([sql, begin_date, end_date]).map do |appointment|
    {
      'appointment_status' => appointment.name,
      'volume_of_appointments' => appointment.appointments.to_s
    }
  end
end

Then(/^I see appointments volumes by state of:$/) do |table|
  expect(table.hashes).to match_array(@count_by_state)
end
