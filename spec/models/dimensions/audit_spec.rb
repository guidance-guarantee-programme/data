require 'rails_helper'

RSpec.describe Dimensions::Audit, type: :model do
  it { is_expected.to validate_presence_of(:fact_table) }
  it { is_expected.to validate_presence_of(:source) }
  it { is_expected.to validate_presence_of(:source_type) }
end
