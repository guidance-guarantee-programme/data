require 'spec_helper'
require 'etl/filter'

RSpec.describe Etl::Filter do
  let(:data) do
    [
      { field_1: 'a', field_2: '1' },
      { field_1: 'a', field_2: '2' },
      { field_1: 'b', field_2: '1' },
      { field_1: 'b', field_2: '2' },
      { field_1: 'c', field_2: '1' }
    ]
  end

  it 'filters records based on the proc passed in on initialization' do
    filter = described_class.new do |r|
      r[:field_1] != 'a'
    end
    filtered = filter.call(records: data, log: {})

    expect(filtered[:records]).to eq(
      [
        { field_1: 'b', field_2: '1' },
        { field_1: 'b', field_2: '2' },
        { field_1: 'c', field_2: '1' }
      ]
    )
  end

  it 'can handle more complex filter' do
    filter = described_class.new do |r|
      r[:field_1] != 'a' && r[:field_2] != '2'
    end
    filtered = filter.call(records: data, log: {})

    expect(filtered[:records]).to eq(
      [
        { field_1: 'b', field_2: '1' },
        { field_1: 'c', field_2: '1' }
      ]
    )
  end

  it 'logs filtered records' do
    filter = described_class.new do |r|
      r[:field_1] != 'a'
    end
    filtered = filter.call(records: data, log: {})

    expect(filtered[:log]).to eq(
      'filtered' => 2
    )
  end

  it 'can set filter name for logging' do
    filter = described_class.new(filter_name: 'field 1 == a') do |r|
      r[:field_1] != 'a'
    end
    filtered = filter.call(records: data, log: {})

    expect(filtered[:log]).to eq(
      'field 1 == a' => 2
    )
  end

  it 'raises an error if no filter block is passed in' do
    expect { described_class.new }.to raise_error(Etl::MissingFilterBlock)
  end
end
