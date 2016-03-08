class PopulateDateDimension
  def initialize(begin_date:, end_date:)
    self.begin_date = begin_date
    self.end_date = end_date
  end

  attr_accessor :begin_date, :end_date

  def call
    (begin_date..end_date).reject(&method(:exists?)).map(&method(:create)).all?
  end

  private

  def exists?(date)
    Dimensions::Date.exists?(date: date)
  end

  def build(date)
    Dimensions::DateBuilder.new(date.year, date.month, date.day).date_dimension
  end

  def create(date)
    build(date).save
  end
end
