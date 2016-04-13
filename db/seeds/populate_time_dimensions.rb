require 'date'

day_part_lookup = {
  0 => 'overnight',
  1 => 'overnight',
  2 => 'overnight',
  3 => 'overnight',
  4 => 'overnight',
  5 => 'overnight',
  6 => 'morning',
  7 => 'morning',
  8 => 'morning',
  9 => 'morning',
  10 => 'midday',
  11 => 'midday',
  12 => 'midday',
  13 => 'midday',
  14 => 'midday',
  15 => 'afternoon',
  16 => 'afternoon',
  17 => 'afternoon',
  18 => 'afternoon',
  19 => 'evening',
  20 => 'evening',
  21 => 'evening',
  22 => 'evening',
  23 => 'evening'
}

(0..23).each do |hour|
  (0..59).each do |minute|
    Dimensions::Time.find_or_create_by!(
      minute_of_day: hour * 60 + minute,
      minute_of_hour: minute,
      hour: hour,
      timezone: 'UTF',
      day_part: day_part_lookup[hour]
    )
  end
end
