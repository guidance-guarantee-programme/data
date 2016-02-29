require 'rails_helper'

RSpec.describe Dimensions::Date, type: :model do
  it { is_expected.to validate_presence_of(:date) }

  it { is_expected.to validate_presence_of(:date_name) }
  it { is_expected.to validate_presence_of(:date_name_abbreviated) }

  it { is_expected.to validate_presence_of(:year) }
  it { is_expected.to validate_numericality_of(:year).only_integer }

  it { is_expected.to validate_presence_of(:quarter) }
  it { is_expected.to validate_numericality_of(:quarter).only_integer }
  it { is_expected.to validate_inclusion_of(:quarter).in_range(1..4) }

  it { is_expected.to validate_presence_of(:month) }
  it { is_expected.to validate_numericality_of(:month).only_integer }
  it { is_expected.to validate_inclusion_of(:month).in_range(1..12) }

  it { is_expected.to validate_presence_of(:month_name) }
  it do
    is_expected.to validate_inclusion_of(:month_name)
      .in_array(%w(January February March April May June July
                   August September October November December))
  end

  it { is_expected.to validate_presence_of(:month_name_abbreviated) }
  it do
    is_expected.to validate_inclusion_of(:month_name_abbreviated)
      .in_array(%w(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec))
  end

  it { is_expected.to validate_presence_of(:week) }
  it { is_expected.to validate_numericality_of(:week).only_integer }
  it { is_expected.to validate_inclusion_of(:week).in_range(1..52) }

  it { is_expected.to validate_presence_of(:day_of_year) }
  it { is_expected.to validate_numericality_of(:day_of_year).only_integer }
  it { is_expected.to validate_inclusion_of(:day_of_year).in_range(1..365) }

  it { is_expected.to validate_presence_of(:day_of_quarter) }
  it { is_expected.to validate_numericality_of(:day_of_quarter).only_integer }
  it { is_expected.to validate_inclusion_of(:day_of_quarter).in_range(1..124) }

  it { is_expected.to validate_presence_of(:day_of_month) }
  it { is_expected.to validate_numericality_of(:day_of_month).only_integer }
  it { is_expected.to validate_inclusion_of(:day_of_month).in_range(1..31) }

  it { is_expected.to validate_presence_of(:day_of_week) }
  it { is_expected.to validate_numericality_of(:day_of_week).only_integer }
  it { is_expected.to validate_inclusion_of(:day_of_week).in_range(1..7) }

  it { is_expected.to validate_presence_of(:day_name) }
  it do
    is_expected.to validate_inclusion_of(:day_name)
      .in_array(%w(Monday Tuesday Wednesday Thursday Friday Saturday Sunday))
  end

  it { is_expected.to validate_presence_of(:day_name_abbreviated) }
  it do
    is_expected.to validate_inclusion_of(:day_name_abbreviated)
      .in_array(%w(Mon Tue Wed Thu Fri Sat Sun))
  end

  it { is_expected.to validate_presence_of(:weekday_weekend) }
  it { is_expected.to validate_inclusion_of(:weekday_weekend).in_array(%w(Weekday Weekend)) }
end
