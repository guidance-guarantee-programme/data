require 'rails_helper'

RSpec.describe Dimensions::State, type: :model do
  it { is_expected.to validate_presence_of(:name) }

  context 'when a default state already exists' do
    before { described_class.create(name: double, default: true) }

    subject { described_class.new(name: 'Completed', default: default) }
    let(:default) { true }

    specify 'only one default state can exist' do
      is_expected.to_not be_valid
    end
  end

  context 'when a non default state exists' do
    before { described_class.create(name: double, default: false) }

    subject { described_class.new(name: 'Completed', default: default) }
    let(:default) { false }

    specify 'additional non default states can exist' do
      is_expected.to be_valid
    end
  end
end
