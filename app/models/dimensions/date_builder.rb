module Dimensions
  class DateBuilder
    def initialize(year, month, day)
      self.date = ::Date.new(year, month, day)
    end

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def date_dimension
      Dimensions::Date.new(
        date: date.strftime('%-d/%-m/%Y'),
        date_name: date_name,
        date_name_abbreviated: date_name_abbreviated,
        year: year,
        quarter: quarter,
        month: month,
        month_name: month_name,
        month_name_abbreviated: month_name_abbreviated,
        week: week,
        day_of_year: day_of_year,
        day_of_quarter: day_of_quarter,
        day_of_month: day_of_month,
        day_of_week: day_of_week,
        day_name: day_name,
        day_name_abbreviated: day_name_abbreviated,
        weekday_weekend: weekday_weekend
      )
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    private

    attr_accessor :date

    def date_name
      date.to_s(:govuk_date)
    end

    def date_name_abbreviated
      date.to_s(:govuk_date_short)
    end

    def year
      date.year
    end

    def quarter
      ((month - 1) / 3) + 1
    end

    def month
      date.month
    end

    def month_name
      date.strftime('%B')
    end

    def month_name_abbreviated
      date.strftime('%b')
    end

    def week
      date.cweek
    end

    def day_of_year
      date.yday
    end

    def day_of_quarter
      (date - date.beginning_of_quarter).to_i + 1
    end

    def day_of_month
      date.mday
    end

    def day_of_week
      date.strftime('%u').to_i
    end

    def day_name
      date.strftime('%A')
    end

    def day_name_abbreviated
      date.strftime('%a')
    end

    def weekday_weekend
      date.saturday? || date.sunday? ? 'Weekend' : 'Weekday'
    end
  end
end
