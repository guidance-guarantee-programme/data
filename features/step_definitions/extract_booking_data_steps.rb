Given(/^the booking system contains booking data$/) do
  # VCR mocks the booking bug data
end

When(/^a list of bookings is requested from the booking api$/) do
  @results = BookingBug.new.call(actions_to_perform: 1)
end

Then(/^a list of bookings is extracted from the booking api$/) do
  expect(@results[:records]).to be_a(Array)
  expect(@results[:records].count).to eq(1444)
end

When(/^booking data is extracted from the booking api$/) do
  BookingBug.new.call
end
