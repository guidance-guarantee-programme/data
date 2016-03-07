require 'spec_helper'
require 'etl/loader'

RSpec.describe Etl::Loader do
  subject { described_class.new(klass: klass) }
  let(:klass) { double(:klass, create!: true, column_names: []) }
  let(:record) { { date_dimension: double(:date_dimension), metadata: { id: 123 } } }
  let(:data) { [record] }

  context 'klass without metadata column' do
    it 'flattens teh field and metadata prior to storage' do
      expect(klass).to receive(:create!).with(date_dimension: record[:date_dimension], id: 123)
      subject.call(records: data, log: {})
    end

    it 'calls once per create once per record' do
      expect(klass).to receive(:create!).twice
      subject.call(records: [record, record], log: {})
    end
  end

  context 'klass with metadata column' do
    before { klass.column_names << :metadata }

    it 'stores the record as is' do
      expect(klass).to receive(:create!).with(record)
      subject.call(records: data, log: {})
    end
  end

  context 'error during save' do
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
