require 'spec_helper'
require 'etl/saver'

RSpec.describe Etl::Saver do
  let(:base_klass) do
    Class.new do
      class << self
        attr_accessor :column_names

        def create!(attr)
          @attr = attr
        end
      end
    end
  end
  subject { described_class.new(klass: klass) }
  let(:record) { { date_dimension: double(:date_dimension), metadata: { id: 123 } } }
  let(:data) { [record] }

  context 'klass without metadata column' do
    let(:klass) { Class.new(base_klass).tap { |c| c.column_names = [] } }

    it 'flattens teh field and metadata prior to storage' do
      expect(klass).to receive(:create!).with(date_dimension: record[:date_dimension], id: 123)
      subject.call(data)
    end

    it 'calls once per create once per record' do
      expect(klass).to receive(:create!).twice
      subject.call([record, record])
    end
  end

  context 'klass with metadata column' do
    let(:klass) { Class.new(base_klass).tap { |c| c.column_names = [:metadata] } }

    it 'stores the record as is' do
      expect(klass).to receive(:create!).with(record)
      subject.call(data)
    end
  end
end
