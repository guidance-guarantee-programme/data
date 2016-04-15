require 'spec_helper'
require 'filters/exclude_cancelled'

RSpec.describe Filters::ExcludeCancelled do
  subject { described_class.new.call }

  context 'when record has is marked as cancelled' do
    let(:record) { { 'is_cancelled' => true, 'id' => 123 } }

    it 'filters the record out' do
      response = subject.call(records: [record], log: Hash.new(0))
      expect(response[:records]).not_to include(record)
    end

    it 'logs the record as being filtered' do
      response = subject.call(records: [record], log: Hash.new(0))
      expect(response[:log]).to include('Cancelled' => 1)
    end
  end

  context 'when record has is marked not cancelled' do
    let(:record) { { 'is_cancelled' => false, 'id' => 123 } }

    it 'it does not get filtered out' do
      response = subject.call(records: [record], log: Hash.new(0))
      expect(response[:records]).to include(record)
    end
  end
end
