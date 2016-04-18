require 'rails_helper'

RSpec.describe Providers::Twilio::OfflineData do
  subject { described_class.load }

  before do
    allow(CSV).to receive(:foreach).tap { |r| raw_calls.each { |raw_call| r.and_yield(raw_call) } }
  end

  describe 'parent_call_sid assignment' do
    context 'when a matching pair of calls exist' do
      let(:raw_calls) do
        [
          call_for(direction: 'inbound', sid: '1234'),
          call_for(direction: 'outbound-dial', sid: '9876')
        ]
      end

      it 'sets the parent_call_sid' do
        expect(subject.map(&:parent_call_sid)).to eq([nil, '1234'])
      end
    end

    context 'multiple matching pairs of calls exist out of order' do
      let(:raw_calls) do
        [
          call_for(direction: 'inbound', sid: '1111', from: 'caller 1'),
          call_for({ direction: 'outbound-dial', sid: '2222', from: 'caller 2' }, 0),
          call_for(direction: 'outbound-dial', sid: '3333', from: 'caller 1'),
          call_for({ direction: 'inbound', sid: '4444', from: 'caller 2' }, 0)
        ]
      end

      it 'sets the parent_call_sid' do
        expect(subject.map(&:parent_call_sid)).to eq([nil, nil, '1111', '2222'])
      end
    end

    context 'multiple calls from the same number' do
      let(:raw_calls) do
        [
          call_for(direction: 'inbound', sid: '1111'),
          call_for(direction: 'outbound-dial', sid: '2222'),
          call_for({ direction: 'outbound-dial', sid: '3333' }, 0)
        ]
      end

      it 'sets the parent_call_sid' do
        expect(subject.map(&:parent_call_sid)).to eq([nil, '1111', nil])
      end
    end

    context 'lonely call at the start' do
      let(:raw_calls) do
        [
          call_for(direction: 'inbound', sid: '1111', from: 'caller 1'),
          call_for({ direction: 'inbound', sid: '2222', from: 'caller 1' }, 0),
          call_for({ direction: 'outbound-dial', sid: '3333', from: 'caller 1' }, 0)
        ]
      end

      it 'sets the parent_call_sid' do
        expect(subject.map(&:parent_call_sid)).to eq([nil, nil, '2222'])
      end
    end

    context 'when matching calls with delay between end_time' do
      let(:raw_calls) do
        [
          call_for(direction: 'inbound', sid: '1234'),
          call_for({ direction: 'outbound-dial', sid: '9876' }, 5)
        ]
      end

      it 'does not set the parent_call_sid' do
        expect(subject.map(&:parent_call_sid).compact).to be_empty
      end
    end

    context 'when calls from different numbers' do
      let(:raw_calls) do
        [
          call_for(direction: 'inbound', sid: '1234'),
          call_for(direction: 'outbound-dial', sid: '9876', from: 'other')
        ]
      end

      it 'does not set the parent_call_sid' do
        expect(subject.map(&:parent_call_sid).compact).to be_empty
      end
    end

    context 'when calls are in the same direction' do
      let(:raw_calls) do
        [
          call_for(direction: 'inbound', sid: '1234'),
          call_for(direction: 'inbound', sid: '9876')
        ]
      end

      it 'does not set the parent_call_sid' do
        expect(subject.map(&:parent_call_sid).compact).to be_empty
      end
    end

    def call_for(params, time_change = 1)
      @time ||= Time.zone.now
      @time += time_change
      {
        duration: 10,
        status: 'complete',
        endtime: @time.to_s
      }.merge(params)
    end
  end
end
