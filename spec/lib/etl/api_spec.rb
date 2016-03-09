require 'spec_helper'
require 'etl/api'

RSpec.describe ETL::API do
  subject do
    described_class.new(
      base_path: '/api/v1/admin/37004/bookings',
      connection: fake_connection
    )
  end

  describe '#auth_token' do
    let(:fake_connection) { double('BookingBug::Connection', auth_token: '12345') }

    it 'uses the BookingBug Connection' do
      expect(fake_connection).to receive(:auth_token)
      subject.auth_token
    end

    context 'when login is successful' do
      it 'extracts the auth token' do
        expect(subject.auth_token).to eq('12345')
      end

      it 'memories the auth token' do
        expect(fake_connection).to receive(:auth_token).once
        subject.auth_token
        subject.auth_token
      end
    end

    context 'when login is not successful' do
      it 'raise an error' do
        allow(fake_connection).to receive(:auth_token).and_raise(StandardError, '401 Unauthorized')
        expect { subject.auth_token }.to raise_error(ETL::UnableToAuthenticate, '401 Unauthorized')
      end
    end
  end

  describe '#all' do
    let(:fake_connection) { double('BookingBug::Connection', auth_token: '12345') }
    let(:page_data_1) do
      double(
        :page_1,
        data: (1..100).to_a,
        next_page: 'https://treasurydev.bookingbug.com/api/v1/admin/37004/bookings?page=2&per_page=100'
      )
    end
    let(:page_data_2) { double(:page_2, data: (1..44).to_a, next_page: nil) }

    context 'when only a single page of data exists' do
      before do
        allow(fake_connection).to receive(:page).and_return(page_data_2)
      end

      it 'returns the array of bookings' do
        result = subject.call(records: [], log: {})
        expect(result[:records].count).to eq(44)
      end

      it 'retrieves a single page of data from the booking bug connection' do
        expect(fake_connection).to receive(:page).once
        subject.call(records: [], log: {})
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
        result = subject.call(records: [], log: {})
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
        subject.call(records: [], log: {})
      end
    end
  end
end
