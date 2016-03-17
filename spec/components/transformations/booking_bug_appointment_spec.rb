require 'rails_helper'

RSpec.describe Transformations::BookingBugAppointment do
  let(:audit_dimension) { instance_double(Dimensions::Audit) }
  subject { described_class.new(audit_dimension: audit_dimension) }

  describe '#audit_dimension' do
    let(:record) { {} }

    it 'return the audit dimension passed in during initialisation' do
      expect(subject.audit_dimension(record)).to eq(audit_dimension)
    end
  end

  describe '#date_dimension' do
    let(:record) { { 'datetime' => '2015-02-04 17:07:58' } }

    it 'looked up from the DB based on the datetime field' do
      expect(Dimensions::Date).to receive(:find_by!).with(date: Date.new(2015, 2, 4))
      subject.date_dimension(record)
    end
  end

  describe '#state_dimension' do
    let(:record) { { '_embedded' => { 'answers' => [booking_answer] } } }

    context 'when the booking status has been set' do
      let(:booking_answer) do
        { '_embedded' => { 'question' => { 'name' => 'Booking status' } }, 'value' => 'completed' }
      end

      it 'looked up from the DB based on the Booking status answers value field' do
        expect(Dimensions::State).to receive(:find_by!).with(name: 'completed')
        subject.state_dimension(record)
      end
    end

    context 'when the booking status has not been set' do
      let(:booking_answer) { { '_embedded' => { 'question' => { 'name' => 'Booking status' } }, 'value' => nil } }

      it 'returns the default state from the database' do
        expect(Dimensions::State).to receive(:find_by!).with(default: true)
        subject.state_dimension(record)
      end
    end
  end

  describe '#reference_number' do
    let(:record) { { 'id' => '1234' } }

    it 'is the "id" field from the record' do
      expect(subject.reference_number(record)).to eq('1234')
    end
  end

  describe '#reference_updated_at' do
    let(:record) { { 'updated_at' => '2015-02-04 17:07:58' } }

    context 'when not using daylight savings time' do
      it 'returns the parsed time based on updated_at field' do
        travel_to Date.new(2016, 3, 15) do
          reference_updated_at = subject.reference_updated_at(record)
          expect(reference_updated_at).to eq(Time.new(2015, 2, 4, 17, 7, 58, '+00:00'))
        end
        Time.zone.now
      end
    end

    context 'when using daylight saving' do
      it 'returns the parsed time based on updated_at field' do
        travel_to Date.new(2016, 6, 15) do
          reference_updated_at = subject.reference_updated_at(record)
          expect(reference_updated_at).to eq(Time.new(2015, 2, 4, 17, 7, 58, '+00:00'))
        end
      end
    end
  end
end
