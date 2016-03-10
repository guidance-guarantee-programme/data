require 'rails_helper'

RSpec.describe PopulateBookingFact, type: :service do
  subject(:service) { described_class.new(date: date, reference_number: reference_number) }

  let(:date) { double }
  let(:reference_number) { double }

  describe '#call' do
    subject { service.call }

    let(:booking_fact) { double }
    let(:date_dimension) { double }

    before do
      allow(Dimensions::Date).to receive(:find_by_date)
        .and_return(date_dimension)

      allow(Facts::Booking).to receive(:create)
        .with(date_dimension: date_dimension, reference_number: reference_number)
        .and_return(booking_fact)
    end

    it 'returns the created booking fact' do
      is_expected.to eq(booking_fact)
    end
  end
end
