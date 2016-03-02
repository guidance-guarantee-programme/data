Given(/^the booking system contains booking data$/) do
  # VCR mocks the booking bug data
end

When(/^a list of bookings is requested from the booking api$/) do
  @bookings = BookingBug.new.extracted
end

Then(/^a list of bookings is extracted from the booking api$/) do
  expect(@bookings).to be_a(Array)
  expect(@bookings.count).to eq(1444)
end

When(/^booking data is extracted from the booking api$/) do
  BookingBug.new.call
end
