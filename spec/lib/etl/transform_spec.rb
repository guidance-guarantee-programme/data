require 'spec_helper'
require 'etl/transform'

RSpec.describe Etl::Transform do
  let(:data) do
    [
      { field_1: 'a', field_2: '1' },
      { field_1: 'a', field_2: '2' },
      { field_1: 'b', field_2: '1' }
    ]
  end

  describe '#add_field' do
    it 'add an output field to the transformed data' do
      transform = described_class.new do |t|
        t.add_field :character, ->(r) { r[:field_1] }
      end

      expect(transform.call(data)).to eq(
        [
          { character: 'a' },
          { character: 'a' },
          { character: 'b' }
        ]
      )
    end

    it 'supports multiple output fields' do
      transform = described_class.new do |t|
        t.add_field :character, ->(r) { r[:field_1] }
        t.add_field :number, ->(r) { r[:field_2] }
      end

      expect(transform.call(data)).to eq(
        [
          { character: 'a', number: '1' },
          { character: 'a', number: '2' },
          { character: 'b', number: '1' }
        ]
      )
    end

    it 'allows more complex transformations' do
      transform = described_class.new do |t|
        t.add_field :value, ->(r) { r[:field_1].upcase * r[:field_2].to_i }
      end

      expect(transform.call(data)).to eq(
        [
          { value: 'A' },
          { value: 'AA' },
          { value: 'B' }
        ]
      )
    end
  end

  describe '#add_metadata' do
    it 'add a metadata field to the transformed data' do
      transform = described_class.new do |t|
        t.add_metadata :character, ->(r) { r[:field_1] }
      end

      expect(transform.call(data)).to eq(
        [
          { metadata: { character: 'a' } },
          { metadata: { character: 'a' } },
          { metadata: { character: 'b' } }
        ]
      )
    end

    it 'supports multiple output fields' do
      transform = described_class.new do |t|
        t.add_metadata :character, ->(r) { r[:field_1] }
        t.add_metadata :number, ->(r) { r[:field_2] }
      end

      expect(transform.call(data)).to eq(
        [
          { metadata: { character: 'a', number: '1' } },
          { metadata: { character: 'a', number: '2' } },
          { metadata: { character: 'b', number: '1' } }
        ]
      )
    end

    it 'allows more complex transformations' do
      transform = described_class.new do |t|
        t.add_metadata :value, ->(r) { r[:field_1].upcase * r[:field_2].to_i }
      end

      expect(transform.call(data)).to eq(
        [
          { metadata: { value: 'A' } },
          { metadata: { value: 'AA' } },
          { metadata: { value: 'B' } }
        ]
      )
    end
  end

  describe 'metadata and fields' do
    it 'can be a mis of the two' do
      transform = described_class.new do |t|
        t.add_field :value, ->(r) { r[:field_1].upcase * r[:field_2].to_i }
        t.add_metadata :number, ->(r) { r[:field_2].to_i }
      end

      expect(transform.call(data)).to eq(
        [
          { value: 'A', metadata: { number: 1 } },
          { value: 'AA', metadata: { number: 2 } },
          { value: 'B', metadata: { number: 1 } }
        ]
      )
    end
  end
end
