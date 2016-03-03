When(/^the booking bug data is transformed$/) do
  @bookings = BookingBug.new.call(actions_to_perform: 3)
end

Then(/^the booking bug data in in the desired format$/) do
  @bookings.each do |booking|
    expect(TransformBookingDataHelper.structure(booking)).to eq(
      date_dimension: Numeric,
      metadata: {
        reference_number: Numeric
      }
    )
  end
end

module TransformBookingDataHelper
  def self.structure(data)
    case data
    when Hash
      result = {}
      data.each do |k, v|
        result[k] = structure(v)
      end
      result
    when Array
      data.map { |entry| structure(entry) }
    else
      data.class
    end
  end
end
