require 'spec_helper'
require 'etl/loader'

RSpec.describe ETL::Loader do
  subject { described_class.new(klass: klass) }
  let(:klass) { double(:klass, create!: true, column_names: [], find_by: found_record) }
  let(:record) { { data: { date_dimension: double(:date_dimension) }, keys: { id: 123 } } }
  let(:data) { [record] }

  context 'when new record' do
    let(:found_record) { nil }
    it 'flattens the data and keys prior to storage' do
      expect(klass).to receive(:create!).with(date_dimension: record[:data][:date_dimension], id: 123)
      subject.call(records: data, log: {})
    end

    it 'calls once per create once per record' do
      expect(klass).to receive(:create!).twice
      subject.call(records: [record, record], log: {})
    end
  end

  context 'when existing record' do
    let(:found_record) { double(:record, update_attributes!: true) }

    it 'flattens the data and keys prior to storage' do
      expect(found_record).to receive(:update_attributes!).with(date_dimension: record[:data][:date_dimension])
      subject.call(records: data, log: {})
    end

    it 'calls once per update once per record' do
      expect(found_record).to receive(:update_attributes!).twice
      subject.call(records: [record, record], log: {})
    end
  end

  context 'error during save' do
    let(:found_record) { nil }

    it 'is logged' do
      allow(klass).to receive(:create!).and_raise('save error')

      saved = subject.call(records: data, log: Hash.new(0))
      expect(saved[:log]).to eq(
        'RuntimeError: save error' => 1
      )
    end

    it 'do not return the records with the error' do
      allow(klass).to receive(:create!).and_raise('save error')

      saved = subject.call(records: data, log: Hash.new(0))
      expect(saved[:records]).to eq([])
    end
  end
end
