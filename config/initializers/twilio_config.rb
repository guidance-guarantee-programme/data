Providers::Twilio.config do |config|
  config.mode = ENV['TWILIO_MODE'] if ENV['TWILIO_MODE'].present?
  config.account_sid = ENV['TWILIO_ACCOUNT_SID']
  config.auth_token = ENV['TWILIO_AUTH_TOKEN']
end
