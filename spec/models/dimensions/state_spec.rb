require 'rails_helper'

RSpec.describe Dimensions::State, type: :model do
  it { is_expected.to validate_presence_of(:name) }

  it 'can only have a single default state' do
    Dimensions::State.create(name: 'apples', default: true)

    state = Dimensions::State.new(name: 'apples', default: true)
    expect(state).not_to be_valid
  end

  it 'allow multiple non-default states' do
    Dimensions::State.create(name: 'apples', default: false)

    state = Dimensions::State.new(name: 'apples', default: false)
    expect(state).to be_valid
  end
end
