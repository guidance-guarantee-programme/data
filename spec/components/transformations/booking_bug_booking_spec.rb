require 'rails_helper'

RSpec.describe Transformations::BookingBugBooking do
  let(:audit_dimension) { instance_double(Dimensions::Audit) }
  subject { described_class.new(audit_dimension: audit_dimension) }

  describe '#audit_dimension' do
    let(:record) { {} }

    it 'return the audit dimension passed in during initialisation' do
      expect(subject.audit_dimension(record)).to eq(audit_dimension)
    end
  end

  describe '#date_dimension' do
    let(:record) { { 'created_at' => '2015-02-04 17:07:58' } }

    it 'is looked up from the DB based on the created at field' do
      expect(Dimensions::Date).to receive(:find_by!).with(date: Date.new(2015, 2, 4))
      subject.date_dimension(record)
    end
  end

  describe '#lead_time' do
    let(:record) { { 'created_at' => '2015-02-04 17:07:58', 'datetime' => '2015-02-04 17:09:58' } }

    it 'is the elapsed time in seconds between created_at and datetime fields' do
      expect(subject.lead_time(record)).to eq(120)
    end
  end

  describe '#reference_number' do
    let(:record) { { 'id' => '1234' } }

    it 'is the "id" field from the record' do
      expect(subject.reference_number(record)).to eq('1234')
    end
  end
end
