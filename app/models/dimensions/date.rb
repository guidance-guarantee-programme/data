module Dimensions
  class Date < ActiveRecord::Base
    validates :date, presence: true

    validates :date_name, presence: true
    validates :date_name_abbreviated, presence: true

    validates :year,
              presence: true,
              numericality: { only_integer: true }

    validates :quarter,
              presence: true,
              numericality: { only_integer: true },
              inclusion: { in: (1..4) }

    validates :month,
              presence: true,
              numericality: { only_integer: true },
              inclusion: { in: (1..12) }

    validates :month_name,
              presence: true,
              inclusion: { in: ::Date::MONTHNAMES }

    validates :month_name_abbreviated,
              presence: true,
              inclusion: { in: ::Date::ABBR_MONTHNAMES }

    validates :week,
              presence: true,
              numericality: { only_integer: true },
              inclusion: { in: (1..52) }

    validates :day_of_year,
              presence: true,
              numericality: { only_integer: true },
              inclusion: { in: (1..365) }

    validates :day_of_quarter,
              presence: true,
              numericality: { only_integer: true },
              inclusion: { in: (1..124) }

    validates :day_of_month,
              presence: true,
              numericality: { only_integer: true },
              inclusion: { in: (1..31) }

    validates :day_of_week,
              presence: true,
              numericality: { only_integer: true },
              inclusion: { in: (1..7) }

    validates :day_name,
              presence: true,
              inclusion: { in: ::Date::DAYNAMES }

    validates :day_name_abbreviated,
              presence: true,
              inclusion: { in: ::Date::ABBR_DAYNAMES }

    validates :weekday_weekend,
              presence: true,
              inclusion: { in: %w(Weekday Weekend) }
  end
end
