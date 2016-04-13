require 'rails_helper'

RSpec.describe Dimensions::Time, type: :model do
  it { is_expected.to validate_presence_of(:minute_of_day) }

  it { is_expected.to validate_presence_of(:minute_of_hour) }
  it { is_expected.to validate_numericality_of(:minute_of_hour).only_integer }
  it { is_expected.to validate_inclusion_of(:minute_of_hour).in_range(0..59) }

  it { is_expected.to validate_presence_of(:hour) }
  it { is_expected.to validate_numericality_of(:hour).only_integer }
  it { is_expected.to validate_inclusion_of(:hour).in_range(0..23) }

  it { is_expected.to validate_presence_of(:timezone) }

  it { is_expected.to validate_presence_of(:day_part) }
end
