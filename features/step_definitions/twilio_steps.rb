Given(/^we import offline twilio call data$/) do
  Providers::Twilio.config { |c| c.mode = Providers::Twilio::Config::OFFLINE }

  begin_date = Date.parse('2016-03-28')
  end_date = Date.parse('2016-04-09')
  PopulateDateDimension.new(begin_date: begin_date, end_date: end_date).call

  load Rails.root.join('db/seeds/populate_time_dimensions.rb')
  load Rails.root.join('db/seeds/populate_outcome_dimensions.rb')

  @results = Providers::Twilio.call
end

When(/^I query calls by date$/) do
  sql = <<-SQL
  SELECT dimensions_dates.date, COUNT(*) AS calls, Sum(facts_calls.call_time) AS total_call_time
  FROM facts_calls
  INNER JOIN dimensions_dates ON (facts_calls.dimensions_date_id = dimensions_dates.id)
  GROUP BY dimensions_dates.date
  SQL

  @calls_by_date = Facts::Appointment.find_by_sql([sql]).map do |summary|
    {
      'date' => summary.date.to_s,
      'call_volume' => summary.calls.to_s,
      'average_call_time' => (summary.total_call_time / summary.calls).to_s
    }
  end
end

Then(/^I see call summary data of:$/) do |table|
  expect(table.hashes).to match_array(@calls_by_date)
end
