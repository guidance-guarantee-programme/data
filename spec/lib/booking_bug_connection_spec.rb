require 'rails_helper'

RSpec.describe BookingBugConnection do
  let(:fake_faraday) { double('Faraday') }
  subject { described_class.new(config: BookingBug.config) }
  before do
    allow(Faraday).to receive(:new).and_return(fake_faraday)
    allow(fake_faraday).to receive(:post).and_yield(fake_request).and_return(fake_response)
  end

  describe '#login' do
    before do
      allow(fake_faraday).to receive(:post).and_yield(fake_request).and_return(fake_response)
    end

    let(:fake_request) { double(:request, url: true, headers: {}, 'body=' => true) }
    let(:fake_response) { double(:response, status: 200, body: { auth_token: '12345' }.to_json) }

    it 'authenticates the username and password with the booking bug environment' do
      expect(fake_request).to receive(:url).with('/api/v1/login')
      expect(fake_request).to receive(:body=).with(/^email=developers@pensionwise.gov.uk&password=.*$/)

      subject.auth_token

      expect(fake_request.headers).to eq(
        'App-Id' => 'fd0cd097',
        'App-Key' => '1962b5a78fca8b79351e969c5832bf60'
      )
    end
  end

  describe '#page' do
    before do
      allow(fake_faraday).to receive(:get).and_yield(fake_request).and_return(fake_response)
    end

    let(:fake_request) { double(:request, url: true, headers: {}, params: {}) }

    let(:fake_response) { double(:response, status: 200, body: raw_data('booking_data_page_2').to_json) }

    it 'retrieves the page of data using authentification fields' do
      expect(fake_request).to receive(:url).with('/api/v1.0/admin/1234/bookings')

      subject.page('/api/v1.0/admin/1234/bookings', '12345')

      expect(fake_request.headers).to eq(
        'App-Id' => 'fd0cd097',
        'App-Key' => '1962b5a78fca8b79351e969c5832bf60',
        'Auth-Token' => '12345'
      )
      expect(fake_request.params).to eq('per_page' => 100)
    end
  end
end
