BookingBug.config do |config|
  config.environment = ENV['BOOKING_BUG_ENVIRONMENT']
  config.company_id = ENV['BOOKING_BUG_COMPANY_ID']
  config.api_key = ENV['BOOKING_BUG_API_KEY']
  config.app_id = ENV['BOOKING_BUG_APP_ID']
  config.email = ENV['BOOKING_BUG_EMAIL']
  config.password = ENV['BOOKING_BUG_PASSWORD']
end
