require 'spec_helper'
require 'etl/log_saver'

RSpec.describe Etl::LogSaver do
  subject { described_class.new(importer: 'BookingBug') }

  it 'creates an Import reocrd' do
    expect(Import).to receive(:create!).with(
      importer: 'BookingBug',
      inserted_records: 5,
      log: { 'Cancelled' => 5 }
    )

    subject.call(records: [1, 2, 3, 4, 5], log: { 'Cancelled' => 5 })
  end
end
