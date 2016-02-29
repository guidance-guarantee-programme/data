Given(/^the date is (.*)$/) do |date|
  @date = Date.parse(date)
end

When(/^we build a date dimension for that date$/) do
  @date_dimension = Dimensions::DateBuilder.new(@date.year, @date.month, @date.day).date_dimension
end

Then(/^we can constrain or group on (.*), eg (.*)$/) do |characteristic, example|
  expect(@date_dimension.public_send(characteristic).to_s).to eq(example)
end
