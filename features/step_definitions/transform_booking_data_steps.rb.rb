When(/^the booking bug data is transformed$/) do
  @results = BookingBug.new.call(actions_to_perform: 3)
end

Then(/^the booking bug data is ready to be saved$/) do
  expect(@results[:records].count).to be > 0

  @results[:records].each do |booking|
    expect(TransformBookingDataHelper.structure(booking)).to eq(
      data: {
        date_dimension: Dimensions::Date
      },
      keys: {
        reference_number: Fixnum
      }
    )
  end
end

module TransformBookingDataHelper
  def self.structure(data)
    case data
    when Hash
      data.each_with_object({}) { |(k, v), h| h[k] = structure(v) }
    when Array
      data.map { |entry| structure(entry) }
    else
      data.class
    end
  end
end

And(/^our stored dataset has date dimensions for the period "([^"]*)" to "([^"]*)"$/) do |from, to|
  from_date = Date.parse(from)
  to_date = Date.parse(to)

  (from_date..to_date).each do |date|
    Dimensions::DateBuilder.new(date.year, date.month, date.day).date_dimension.save!
  end
end

Then(/^errors during the transformation process are logged$/) do
  expect(@results[:log]).to include("ActiveRecord::RecordNotFound: Couldn't find Dimensions::Date")
end
