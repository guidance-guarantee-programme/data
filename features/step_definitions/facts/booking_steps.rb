Then(/^the extracted booking data is stored as facts$/) do
  expect(Facts::Booking.count).to eq(1439)
end
