require 'rails_helper'

RSpec.describe PopulateDateDimension, type: :service do
  subject(:service) { described_class.new(begin_date: begin_date, end_date: end_date) }

  let(:begin_date) { Date.new(2016, 1, 1) }
  let(:end_date) { Date.new(2016, 1, 2) }

  describe '#call' do
    subject { service.call }

    context 'when no dimensions exist for the date period' do
      before do
        allow(Dimensions::Date).to receive(:exists?).and_return(false)
      end

      it 'returns true' do
        is_expected.to be_truthy
      end

      it 'creates date dimensions' do
        expect { subject }.to change(Dimensions::Date, :count).by(2)
      end
    end

    context 'when dimensions exist for the date period' do
      before do
        allow(Dimensions::Date).to receive(:exists?).and_return(true)
      end

      it 'returns true' do
        is_expected.to be_truthy
      end

      it 'creates date dimensions' do
        expect { subject }.to_not change(Dimensions::Date, :count)
      end
    end
  end
end
