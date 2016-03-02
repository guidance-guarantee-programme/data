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

    expect(filter.call(data)).to eq(
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

    expect(filter.call(data)).to eq(
      [
        { field_1: 'b', field_2: '1' },
        { field_1: 'c', field_2: '1' }
      ]
    )
  end

  it 'raises an error if no filter block is passed in' do
    expect { described_class.new }.to raise_error(Etl::MissingFilterBlock)
  end
end
