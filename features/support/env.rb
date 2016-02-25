$LOAD_PATH << './lib'
require 'booking_bug'
require 'pry'

# Setup some sensible defaults for running tests.

ENV['BOOKING_BUG_ENVIRONMENT']  ||= 'treasurydev'
ENV['BOOKING_BUG_COMPANY']      ||= '37004'

# account specific settings - these should be overwritten with test/support account
ENV['BOOKING_BUG_API_KEY']      ||= '1962b5a78fca8b79351e969c5832bf60'
ENV['BOOKING_BUG_APP_ID']       ||= 'fd0cd097'
ENV['BOOKING_BUG_EMAIL']        ||= 'developers@pensionwise.gov.uk'
ENV['BOOKING_BUG_PASSWORD']     ||= 'zZuNFWRD9IqD'
