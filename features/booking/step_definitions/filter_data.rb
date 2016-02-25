Given(/^the booking bug data has new entries since the last extract$/) do
  # VCR mocks the booking bug data

  # list of records that already exist => @bookings.map{|d| d['id']}.shuffle.take(20)
  @created_booking_ids = [
    2764, 3308, 2433, 331,  2590,
    2245, 3029, 2109, 1669, 3251,
    445,  1061, 351,  2463, 1838,
    2194, 873,  545,  1393, 1399
  ]

  # TODO: replace this with database records for each ID.
  allow(Facts::Booking).to receive(:any?) do |query|
    @created_booking_ids.include?(query[:booking_bug_id])
  end
end

When(/^the booking bug data is filtered$/) do
  @bookings = BookingBug.new.filtered
end

Then(/^only new entries are returned$/) do
  expect(@bookings.detect { |b| @created_booking_ids.include?(b['id']) }).to be_nil
  expect(@bookings.count).to eq(1444 - @created_booking_ids.count)
end
