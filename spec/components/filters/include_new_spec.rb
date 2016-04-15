require 'rails_helper'

RSpec.describe Filters::IncludeNew do
  subject { described_class.new(db_class: Facts::Booking).call }

  context 'when Booking Fact already exists for the given id' do
    let(:record) { { 'id' => '123' } }
    before do
      allow(Facts::Booking).to receive(:exists?).and_return(true)
    end

    it 'filters the record out' do
      response = subject.call(records: [record], log: Hash.new(0))
      expect(response[:records]).not_to include(record)
    end

    it 'logs the record as being filtered' do
      response = subject.call(records: [record], log: Hash.new(0))
      expect(response[:log]).to include('Existing record' => 1)
    end
  end

  context 'when a Booking fact does not exists for the given id' do
    let(:record) { { 'id' => '123' } }

    it 'does not filter the record' do
      response = subject.call(records: [record], log: Hash.new(0))
      expect(response[:records]).to include(record)
    end
  end
end
