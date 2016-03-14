When(/^the booking bug data is transformed$/) do
  @results = BookingBug::Bookings.new.call(actions_to_perform: 3)
end

Then(/^the booking bug data is ready to be saved$/) do
  expect(@results[:records].count).to be > 0

  @results[:records].each do |booking|
    expect(TransformBookingDataHelper.structure(booking)).to eq(
      data: {
        date_dimension: Dimensions::Date,
        audit_dimension: Dimensions::Audit,
        lead_time: Fixnum
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

And(/^our stored dataset has date dimensions for the period "([^"]*)" to "([^"]*)"$/) do |begin_date, end_date|
  begin_date = Date.parse(begin_date)
  end_date = Date.parse(end_date)

  PopulateDateDimension.new(begin_date: begin_date, end_date: end_date).call

  original_find_by = Dimensions::Date.method(:find_by!)

  allow(Dimensions::Date).to receive(:find_by!) do |query|
    if (begin_date..end_date).cover?(query[:date])
      original_find_by.call(query)
    else
      raise(ActiveRecord::RecordNotFound, "Couldn't find Dimensions::Date")
    end
  end
end

Then(/^errors during the transformation process are logged$/) do
  expect(@results[:log]).to include("ActiveRecord::RecordNotFound: Couldn't find Dimensions::Date")
end
