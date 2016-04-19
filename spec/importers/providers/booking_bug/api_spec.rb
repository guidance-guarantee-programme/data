require 'rails_helper'

RSpec.describe Providers::BookingBug::API do
  let(:config) { instance_double(Providers::BookingBug::Config, company_id: '37004') }
  let(:connection) { instance_double(Providers::BookingBug::Connection) }

  subject { described_class.new(config) }

  before do
    allow(Providers::BookingBug::Connection).to receive(:new).with(config: config).and_return(fake_connection)
  end

  describe '#auth_token' do
    let(:fake_connection) { instance_double(Providers::BookingBug::Connection, auth_token: '12345') }

    it 'uses the BookingBug Connection' do
      expect(fake_connection).to receive(:auth_token)
      subject.auth_token(fake_connection)
    end

    context 'when login is successful' do
      it 'extracts the auth token' do
        expect(subject.auth_token(fake_connection)).to eq('12345')
      end

      it 'memories the auth token' do
        expect(fake_connection).to receive(:auth_token).once
        subject.auth_token(fake_connection)
        subject.auth_token(fake_connection)
      end
    end

    context 'when login is not successful' do
      it 'raise an error' do
        allow(fake_connection).to receive(:auth_token).and_raise(StandardError, '401 Unauthorized')
        expect { subject.auth_token(fake_connection) }.to raise_error(
          Providers::BookingBug::API::UnableToAuthenticate,
          '401 Unauthorized'
        )
      end
    end
  end

  describe '#all' do
    let(:fake_connection) { instance_double(Providers::BookingBug::Connection, auth_token: '12345') }
    let(:page_data_1) do
      double(
        :page_1,
        data: (1..100).to_a,
        next_page_url: 'https://treasurydev.bookingbug.com/api/v1/admin/37004/bookings?page=2&per_page=100'
      )
    end
    let(:page_data_2) { double(:page_2, data: (1..44).to_a, next_page_url: nil) }

    context 'when only a single page of data exists' do
      before do
        allow(fake_connection).to receive(:page).and_return(page_data_2)
      end

      it 'returns the array of bookings' do
        result = subject.load(records: [], log: {})
        expect(result[:records].count).to eq(44)
      end

      it 'retrieves a single page of data from the booking bug connection' do
        expect(fake_connection).to receive(:page).once
        subject.load(records: [], log: {})
      end
    end

    context 'when multiple pages of data exist' do
      before do
        allow(fake_connection).to receive(:page).with(
          '/api/v1/admin/37004/bookings',
          anything
        ).and_return(page_data_1)
        allow(fake_connection).to receive(:page).with(
          'https://treasurydev.bookingbug.com/api/v1/admin/37004/bookings?page=2&per_page=100',
          anything
        ).and_return(page_data_2)
      end

      it 'returns the array of all bookings from both requests' do
        result = subject.load(records: [], log: {})
        expect(result[:records].count).to eq(144)
      end

      it 'it retrieves each page of data from the booking bug connection once' do
        expect(fake_connection).to receive(:page).with(
          '/api/v1/admin/37004/bookings',
          '12345'
        ).once
        expect(fake_connection).to receive(:page).with(
          'https://treasurydev.bookingbug.com/api/v1/admin/37004/bookings?page=2&per_page=100',
          '12345'
        ).once
        subject.load(records: [], log: {})
      end
    end
  end
end
