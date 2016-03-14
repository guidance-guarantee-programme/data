require 'rails_helper'

RSpec.describe Filters::IncludeNewOrChanged do
  subject { described_class.new(db_class: Facts::Appointment).call }

  context 'when Booking Fact already exists for the given id' do
    before do
      allow(Facts::Appointment).to receive(:exists?).and_return(false)
      allow(Facts::Appointment).to receive(:exists?).with(reference_number: '123').and_return(true)
    end

    context 'when record has not been edited in the last 7 days' do
      let(:record) { { 'id' => '123', 'updated_at' => 8.days.ago.to_s } }

      it 'filters the record out' do
        response = subject.call(records: [record], log: Hash.new(0))
        expect(response[:records]).not_to include(record)
      end

      it 'logs the record as being filtered' do
        response = subject.call(records: [record], log: Hash.new(0))
        expect(response[:log]).to include('Existing/Unchanged record' => 1)
      end
    end

    context 'when record has been edited in the last 7 days' do
      let(:updated_at) { Time.zone.parse(5.days.ago.to_s) } # deal with subsecond rounding
      let(:record) { { 'id' => '123', 'updated_at' => updated_at.to_s } }

      context 'edit is more recent than last update' do
        before do
          allow(Facts::Appointment).to receive(:exists?).with(
            ['reference_number = ? and reference_updated_at < ?', '123', updated_at]
          ).and_return(true)
        end

        it 'does not filter the record' do
          response = subject.call(records: [record], log: Hash.new(0))
          expect(response[:records]).to include(record)
        end
      end

      context 'edit is after last update' do
        it 'filters the record out' do
          response = subject.call(records: [record], log: Hash.new(0))
          expect(response[:records]).not_to include(record)
        end

        it 'logs the record as being filtered' do
          response = subject.call(records: [record], log: Hash.new(0))
          expect(response[:log]).to include('Existing/Unchanged record' => 1)
        end
      end
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
