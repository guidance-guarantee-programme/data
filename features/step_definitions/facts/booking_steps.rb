Then(/^the extracted booking data is stored as facts$/) do
  expect(Facts::Booking.count).to eq(@results[:records].count)

  bookings_by_date = Facts::Booking.joins(:date_dimension).group('dimensions_dates.date').count
  expect(bookings_by_date).to include(
    Date.new(2015, 2, 12) => 3,
    Date.new(2015, 2, 16) => 8,
    Date.new(2015, 2, 19) => 46,
    Date.new(2015, 3, 10) => 17,
    Date.new(2015, 3, 13) => 53,
    Date.new(2015, 3, 14) => 32,
    Date.new(2015, 3, 16) => 87,
    Date.new(2015, 3, 2) => 35,
    Date.new(2015, 3, 22) => 104,
    Date.new(2015, 3, 27) => 56,
    Date.new(2015, 3, 28) => 1,
    Date.new(2015, 4, 1) => 60,
    Date.new(2015, 4, 15) => 1,
    Date.new(2015, 4, 3) => 35,
    Date.new(2015, 4, 8) => 31,
    Date.new(2015, 5, 20) => 2,
    Date.new(2015, 5, 5) => 1,
    Date.new(2015, 5, 7) => 2,
    Date.new(2015, 9, 10) => 4,
    Date.new(2015, 9, 21) => 1,
    Date.new(2015, 9, 24) => 2
  )
end
