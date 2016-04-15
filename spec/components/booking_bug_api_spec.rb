require 'rails_helper'

RSpec.describe BookingBugAPI do
  let(:config) { instance_double(BookingBug::Config, company_id: '1234') }
  let(:connection) { instance_double(BookingBugConnection) }
  subject { described_class.new(config) }

  it 'creates a new BookingBug::Connection from the configuration details' do
    expect(BookingBugConnection).to receive(:new).with(config: config).and_return(connection)

    expect(ETL::API).to receive(:new).with(
      base_path: '/api/v1/admin/1234/bookings',
      connection: connection
    )

    subject.call
  end
end
