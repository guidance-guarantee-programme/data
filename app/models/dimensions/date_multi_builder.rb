module Dimensions
  class DateMultiBuilder
    def initialize(date)
      self.date = date
    end

    def date_dimensions
      return [Dimensions::Date.find_by(date: date)] if Dimensions::Date.find_by(date: date)

      last_day_with_dimension = Dimensions::Date.maximum(:date) || Date.new(2015, 1, 1)
      (last_day_with_dimension + 1..date).map do |d|
        Dimensions::DateBuilder.new(d.year, d.month, d.mday).date_dimension
      end
    end

    def date_dimensions!
      date_dimensions.each(&:save!)
    end
  end
end
