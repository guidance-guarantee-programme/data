Given(/^the booking bug data has new entries since the last extract$/) do
  # VCR mocks the booking bug data

  # list of records that already exist => @bookings.map{|d| d['id']}.shuffle.take(20)
  @created_booking_ids = [
    2764, 3308, 2433, 331,  2590,
    2245, 3029, 2109, 1669, 3251,
    445,  1061, 351,  2463, 1838,
    2194, 873,  545,  1393, 1399
  ]

  audit_dimension = Dimensions::Audit.create!(fact_table: 'Bookings', source: 'BookingBug', source_type: 'api')
  date_dimension = Dimensions::DateBuilder.new(2016, 2, 1).date_dimension
  date_dimension.save!
  @created_booking_ids.each do |id|
    Facts::Booking.create!(
      reference_number: id,
      date_dimension: date_dimension,
      audit_dimension: audit_dimension)
  end
end

When(/^the booking bug data is filtered$/) do
  @results = BookingBug.new.call(actions_to_perform: 2)
end

Then(/^only new entries are returned$/) do
  expect(@results[:records].detect { |b| @created_booking_ids.include?(b['id']) }).to be_nil
end
