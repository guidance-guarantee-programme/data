module Dimensions
  class Time < ActiveRecord::Base
    validates :minute_of_day,
              presence: true,
              uniqueness: true

    validates :minute_of_hour,
              presence: true,
              uniqueness: { scope: :hour },
              numericality: { only_integer: true },
              inclusion: { in: (0..59) }

    validates :hour,
              presence: true,
              numericality: { only_integer: true },
              inclusion: { in: (0..23) }

    validates :timezone, presence: true
    validates :day_part, presence: true
  end
end
