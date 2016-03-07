require 'rails_helper'

RSpec.describe Import, type: :model do
  it { is_expected.to validate_presence_of(:importer) }
  it { is_expected.to validate_presence_of(:inserted_records) }
end
