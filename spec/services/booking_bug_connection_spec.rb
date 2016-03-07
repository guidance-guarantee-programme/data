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

    let(:fake_request) { double(:request, url: true, 'body=' => true) }
    let(:fake_response) { double(:response, status: 200, body: { auth_token: '12345' }.to_json) }

    it 'authenticates the username and password with the booking bug environment' do
      expect(fake_request).to receive(:url).with('/api/v1/login')
      expect(fake_request).to receive(:body=).with(/^email=developers@pensionwise.gov.uk&password=.*$/)
      expect(fake_request).to receive(:headers=).with(
        'App-Id' => 'fd0cd097',
        'App-Key' => '1962b5a78fca8b79351e969c5832bf60'
      )

      subject.auth_token
    end
  end

  describe '#page' do
    before do
      allow(fake_faraday).to receive(:get).and_yield(fake_request).and_return(fake_response)
    end

    let(:fake_request) { double(:request, params: {}) }

    let(:fake_response) { double(:response, status: 200, body: double(:page, next_page: nil, data: (1..44).to_a)) }

    it 'retrieves the page of data using authentification fields' do
      expect(fake_request).to receive(:url).with('/api/v1.0/admin/1234/bookings')
      expect(fake_request).to receive(:headers=).with(
        'App-Id' => 'fd0cd097',
        'App-Key' => '1962b5a78fca8b79351e969c5832bf60',
        'Auth-Token' => '12345'
      )

      subject.page('/api/v1.0/admin/1234/bookings', '12345')

      expect(fake_request.params).to eq(
        'per_page' => 100,
        'include_cancelled' => true
      )
    end
  end
end
