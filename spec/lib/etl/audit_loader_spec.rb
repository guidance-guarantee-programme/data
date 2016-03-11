require 'spec_helper'
require 'etl/audit_loader'

RSpec.describe ETL::AuditLoader do
  let(:audit_dimension) { instance_double(Dimensions::Audit) }
  subject { described_class.new(audit_dimension: audit_dimension) }

  it 'creates an Import reocrd' do
    expect(audit_dimension).to receive(:update_attributes!).with(
      inserted_records: 5,
      log: { 'Cancelled' => 5 }
    )

    subject.call(records: [1, 2, 3, 4, 5], log: { 'Cancelled' => 5 })
  end
end
