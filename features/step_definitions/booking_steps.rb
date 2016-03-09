Given(/^booking data exists in the data warehouse$/) do
  @begin_date = Date.parse('1/1/2016')
  @end_date = Date.parse('3/1/2016')

  PopulateDateDimension.new(begin_date: @begin_date, end_date: @end_date).call

  @created = @begin_date.upto(@end_date)
                        .map { |date| { date: date, reference_number: SecureRandom.uuid } }
                        .map(&PopulateBookingFact.method(:new))
                        .map(&:call)
                        .size
end

When(/^I query for bookings between two dates$/) do
  sql = <<-SQL
    SELECT COUNT(*) AS bookings
    FROM facts_bookings
    INNER JOIN dimensions_dates ON (facts_bookings.dimensions_date_id = dimensions_dates.id)
    WHERE dimensions_dates.date BETWEEN ? AND ?
  SQL

  @count = Facts::Booking.count_by_sql([sql, @begin_date, @end_date])
end

Then(/^I am given a count of the number of bookings$/) do
  expect(@count).to eq(@created)
end
