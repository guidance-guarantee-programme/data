class PopulateBookingFact
  def initialize(date:, reference_number:)
    self.date = date
    self.reference_number = reference_number
  end

  def call
    Facts::Booking.create(date_dimension: date_dimension, reference_number: reference_number)
  end

  private

  attr_accessor :date, :reference_number

  def date_dimension
    Dimensions::Date.find_by_date(date)
  end
end
