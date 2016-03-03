Given(/^the booking system contains booking data$/) do
  # VCR mocks the booking bug data
end

When(/^a list of bookings is requested from the booking api$/) do
  @bookings = Etl::Api.new(
    base_path: "/api/v1/admin/#{BookingBug.config.company_id}/bookings",
    connection: BookingBugConnection.new(config: BookingBug.config)
  ).call
end

Then(/^a list of bookings is extracted from the booking api$/) do
  expect(@bookings).to be_a(Array)
  expect(@bookings.count).to eq(1444)
end

When(/^booking data is extracted from the booking api$/) do
  BookingBug.new.call
end
