require 'rails_helper'

RSpec.describe Transformations::TwilioCall do
  let(:audit_dimension) { instance_double(Dimensions::Audit) }

  subject { described_class.new(audit_dimension: audit_dimension) }

  describe '#audit_dimension' do
    let(:record) { double }

    it 'return the audit dimension passed in during initialisation' do
      expect(subject.audit_dimension(record)).to eq(audit_dimension)
    end
  end

  describe '#date_dimension' do
    let(:record) { double(start_time: '2015-02-04 17:07:58') }

    it 'is looked up from the DB based on the created at field' do
      date_dimension = double
      allow(Dimensions::Date).to receive(:find_by!).with(date: Date.new(2015, 2, 4)).and_return(date_dimension)
      expect(subject.date_dimension(record)).to eq(date_dimension)
    end
  end

  describe '#time_dimension' do
    let(:record) { double(start_time: '2015-02-04 17:07:58') }

    it 'is looked up from the DB based on the created at field' do
      time_dimension = double
      allow(Dimensions::Time).to receive(:find_by!).with(minute_of_day: (17 * 60 + 7)).and_return(time_dimension)
      expect(subject.time_dimension(record)).to eq(time_dimension)
    end
  end

  describe '#outcome_dimension' do
    let(:outcome_dimension) { double }

    context 'when outbound_duration is longer than MINIMUM_CALL_TIME' do
      let(:record) { double(outbound_duration: 11) }

      it 'is set to forwarded' do
        allow(Dimensions::Outcome).to receive(:forwarded).and_return(outcome_dimension)
        expect(subject.outcome_dimension(record)).to eq(outcome_dimension)
      end
    end

    context 'when outbound_duration is less than or equal to MINIMUM_CALL_TIME' do
      let(:record) { double(outbound_duration: 10) }

      it 'is set to abandoned' do
        allow(Dimensions::Outcome).to receive(:abandoned).and_return(outcome_dimension)
        expect(subject.outcome_dimension(record)).to eq(outcome_dimension)
      end
    end

    context 'when outbound_duration is not set' do
      let(:record) { double(outbound_duration: nil) }

      it 'is set to abandoned' do
        allow(Dimensions::Outcome).to receive(:abandoned).and_return(outcome_dimension)
        expect(subject.outcome_dimension(record)).to eq(outcome_dimension)
      end
    end
  end

  describe 'call times and timing' do
    context 'when inbound and outbound durations exist' do
      let(:record) { double(inbound_duration: 15, outbound_duration: 10) }

      it 'call time is based on inbound duration' do
        expect(subject.call_time(record)).to eq(15)
      end

      it 'talk rime is based on outbound duration' do
        expect(subject.talk_time(record)).to eq(10)
      end

      it 'ring time is the difference between inbound and outbound duration' do
        expect(subject.ring_time(record)).to eq(5)
      end
    end

    context 'when only an inbound durations exist' do
      let(:record) { double(inbound_duration: 15, outbound_duration: nil) }

      it 'call time is based on inbound duration' do
        expect(subject.call_time(record)).to eq(15)
      end

      it 'talk rime is set to 0' do
        expect(subject.talk_time(record)).to eq(0)
      end

      it 'ring time is the inbound' do
        expect(subject.ring_time(record)).to eq(15)
      end
    end

    context 'when only an outbound durations exist' do
      let(:record) { double(inbound_duration: nil, outbound_duration: 10) }

      it 'call time is based on outbound duration' do
        expect(subject.call_time(record)).to eq(10)
      end

      it 'talk rime is based on outbound duration' do
        expect(subject.talk_time(record)).to eq(10)
      end

      it 'ring time is set to 0' do
        expect(subject.ring_time(record)).to eq(0)
      end
    end
  end

  describe '#cost' do
    context 'both inbound_price and outbound_price exist' do
      let(:record) { double(outbound_price: 0.01, inbound_price: 0.007) }

      it 'is the "id" field from the record' do
        expect(subject.cost(record)).to eq(0.017)
      end
    end

    context 'only inbound_price exists' do
      let(:record) { double(outbound_price: nil, inbound_price: 0.007) }

      it 'is the "id" field from the record' do
        expect(subject.cost(record)).to eq(0.007)
      end
    end

    context 'only outbound_price exists' do
      let(:record) { double(outbound_price: 0.01, inbound_price: nil) }

      it 'is the "id" field from the record' do
        expect(subject.cost(record)).to eq(0.01)
      end
    end
  end

  describe '#reference_number' do
    let(:record) { double(sid: '1234') }

    it 'is the "id" field from the record' do
      expect(subject.reference_number(record)).to eq('1234')
    end
  end
end
