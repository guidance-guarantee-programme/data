Given(/^the booking system contains booking data$/) do
  # VCR mocks the booking bug data
end

When(/^a list of bookings is requested from the booking api$/) do
  @results = BookingBug.new.call(actions_to_perform: 1)
end

Then(/^a list of bookings is extracted from the booking api$/) do
  expect(@results[:records]).to be_a(Array)

  group_by_date_and_state = @results[:records].group_by do |r|
    {
      date: Date.parse(r['created_at']).to_s,
      cancelled: r['is_cancelled']
    }
  end

  count_by_date_and_state = group_by_date_and_state.map do |key, records|
    key.merge(count: records.count)
  end

  # use include here as it will continue to grow if data from BookingBug is refreshed
  expect(count_by_date_and_state).to include(
    { date: '2015-02-04', cancelled: true, count: 1 },
    { date: '2015-02-09', cancelled: true, count: 1 },
    { date: '2015-02-11', cancelled: false, count: 1 },
    { date: '2015-02-11', cancelled: true, count: 3 },
    { date: '2015-02-12', cancelled: true, count: 3 },
    { date: '2015-02-13', cancelled: true, count: 2 },
    { date: '2015-02-16', cancelled: true, count: 8 },
    { date: '2015-02-17', cancelled: true, count: 8 },
    { date: '2015-02-17', cancelled: false, count: 1 },
    { date: '2015-02-18', cancelled: true, count: 6 },
    { date: '2015-02-19', cancelled: true, count: 38 },
    { date: '2015-02-19', cancelled: false, count: 8 },
    { date: '2015-02-20', cancelled: true, count: 19 },
    { date: '2015-02-23', cancelled: false, count: 7 },
    { date: '2015-02-23', cancelled: true, count: 8 },
    { date: '2015-02-24', cancelled: false, count: 6 },
    { date: '2015-02-24', cancelled: true, count: 4 },
    { date: '2015-02-25', cancelled: false, count: 58 },
    { date: '2015-02-25', cancelled: true, count: 58 },
    { date: '2015-02-26', cancelled: true, count: 61 },
    date: '2015-02-26', cancelled: false, count: 56
  )
end

When(/^booking data is extracted from the booking api$/) do
  @results = BookingBug.new.call
end
