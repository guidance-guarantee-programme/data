require 'spec_helper'
require 'etl/transform'

RSpec.describe ETL::Transform do
  let(:data) do
    [
      { field_1: 'a', field_2: '1' },
      { field_1: 'a', field_2: '2' },
      { field_1: 'b', field_2: '1' }
    ]
  end

  describe '#add_field' do
    it 'add a data field to the transformed data' do
      transform = described_class.new do |t|
        t.add_field :character, ->(r) { r[:field_1] }
      end

      expect(transform.call(records: data, log: {})).to eq(
        records: [
          { data: { character: 'a' } },
          { data: { character: 'a' } },
          { data: { character: 'b' } }
        ],
        log: {}
      )
    end

    it 'supports multiple output fields' do
      transform = described_class.new do |t|
        t.add_field :character, ->(r) { r[:field_1] }
        t.add_field :number, ->(r) { r[:field_2] }
      end

      expect(transform.call(records: data, log: {})).to eq(
        records: [
          { data: { character: 'a', number: '1' } },
          { data: { character: 'a', number: '2' } },
          { data: { character: 'b', number: '1' } }
        ],
        log: {}
      )
    end

    it 'allows more complex transformations' do
      transform = described_class.new do |t|
        t.add_field :value, ->(r) { r[:field_1].upcase * r[:field_2].to_i }
      end

      expect(transform.call(records: data, log: {})).to eq(
        records: [
          { data: { value: 'A' } },
          { data: { value: 'AA' } },
          { data: { value: 'B' } }
        ],
        log: {}
      )
    end
  end

  describe '#add_key_field' do
    it 'add a key field to the transformed data' do
      transform = described_class.new do |t|
        t.add_key_field :character, ->(r) { r[:field_1] }
      end

      expect(transform.call(records: data, log: {})).to eq(
        records: [
          { keys: { character: 'a' } },
          { keys: { character: 'a' } },
          { keys: { character: 'b' } }
        ],
        log: {}
      )
    end

    it 'supports multiple output fields' do
      transform = described_class.new do |t|
        t.add_key_field :character, ->(r) { r[:field_1] }
        t.add_key_field :number, ->(r) { r[:field_2] }
      end

      expect(transform.call(records: data, log: {})).to eq(
        records: [
          { keys: { character: 'a', number: '1' } },
          { keys: { character: 'a', number: '2' } },
          { keys: { character: 'b', number: '1' } }
        ],
        log: {}
      )
    end

    it 'allows more complex transformations' do
      transform = described_class.new do |t|
        t.add_key_field :value, ->(r) { r[:field_1].upcase * r[:field_2].to_i }
      end

      expect(transform.call(records: data, log: {})).to eq(
        records: [
          { keys: { value: 'A' } },
          { keys: { value: 'AA' } },
          { keys: { value: 'B' } }
        ],
        log: {}
      )
    end
  end

  describe 'keys and data fields' do
    it 'can be used together' do
      transform = described_class.new do |t|
        t.add_field :value, ->(r) { r[:field_1].upcase * r[:field_2].to_i }
        t.add_key_field :number, ->(r) { r[:field_2].to_i }
      end

      expect(transform.call(records: data, log: {})).to eq(
        records: [
          { data: { value: 'A' }, keys: { number: 1 } },
          { data: { value: 'AA' }, keys: { number: 2 } },
          { data: { value: 'B' }, keys: { number: 1 } }
        ],
        log: {}
      )
    end
  end

  describe 'errors during transformation' do
    let(:value_transformation) do
      ->(r) { r[:field_1] == 'a' ? raise("invalid: #{r[:field_2]}") : "winner: #{r[:field_1]}" }
    end
    let(:transform) do
      described_class.new do |t|
        t.add_field :value, value_transformation
      end
    end
    let(:transformed_data) { transform.call(records: data, log: Hash.new(0)) }

    it 'are logged in the errors object' do
      expect(transformed_data[:log]).to eq(
        'RuntimeError: invalid: 1' => 1,
        'RuntimeError: invalid: 2' => 1
      )
    end

    it 'do not return the records with the error' do
      expect(transformed_data[:records]).to eq(
        [
          { data: { value: 'winner: b' } }
        ]
      )
    end
  end
end
