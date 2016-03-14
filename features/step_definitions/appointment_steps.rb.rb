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

Given(/^we import booking bug appointment data between "([^"]*)" and "([^"]*)"$/) do |begin_date, end_date|
  # filter import on date as date dimension is populated from seeds
  begin_date = Date.parse(begin_date)
  end_date = Date.parse(end_date)

  original_find_by = Dimensions::Date.method(:find_by!)

  allow(Dimensions::Date).to receive(:find_by!) do |query|
    if (begin_date..end_date).cover?(query[:date])
      original_find_by.call(query)
    else
      raise(ActiveRecord::RecordNotFound, "Couldn't find Dimensions::Date")
    end
  end

  @results = BookingBug::Appointments.new.call
end
