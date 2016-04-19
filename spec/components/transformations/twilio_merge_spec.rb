require 'rails_helper'

RSpec.describe Transformations::TwilioMerge do
  let(:inbound_call_path) { Rails.root.join('spec/fixtures/inbound_call.csv') }
  let(:outbound_call_path) { Rails.root.join('spec/fixtures/outbound_call.csv') }
  let(:inbound_call) { Providers::Twilio::OfflineData.load(inbound_call_path).first }
  let(:outbound_call) { Providers::Twilio::OfflineData.load(outbound_call_path).first }

  subject { described_class.new }

  context 'when call pair are passed in' do
    before do
      outbound_call.parent_call_sid = inbound_call.sid
    end

    let(:records) { [outbound_call, inbound_call] }

    it 'creates a merged record with the inbound and outbound calls correct assigned' do
      expect(described_class::Record).to receive(:new).with([inbound_call, outbound_call])
      subject.call(records: records, log: {})
    end
  end

  context 'when an inbound call without an outbound pair is passed in' do
    let(:records) { [inbound_call] }

    it 'creates a merged with the inbound call' do
      expect(described_class::Record).to receive(:new).with([inbound_call])
      subject.call(records: records, log: {})
    end
  end

  context 'when an outbound call without an inbound pair is passed in' do
    let(:records) { [outbound_call] }

    it 'creates a merged with the inbound call' do
      expect(described_class::Record).to receive(:new).with([outbound_call])
      subject.call(records: records, log: {})
    end
  end

  context 'when more than two assocaited calls' do
    let(:records) { [outbound_call, outbound_call, outbound_call] }

    it 'it logs InvalidCallPairs error' do
      response = subject.call(records: records, log: {})
      expect(response[:log]).to eq('Transformations::TwilioMerge::InvalidCallPairs: 3 when maximum of 2 expected' => 1)
    end
  end
end
