module Config
  cattr_accessor :booking_bug

  class BookingBug
    attr_accessor :environment, :company_id, :api_key, :app_id, :email, :password

    def initialize
      yield(self) if block_given?
    end

    def attributes
      instance_variable_names.map { |n| n.gsub(/@/, '') }
    end
  end
end

if Rails.env.test? || Rails.env.development?
  Config.booking_bug = Config::BookingBug.new do |bb|
    bb.environment  = 'treasurydev'
    bb.company_id   = '37004'
    bb.api_key      = '1962b5a78fca8b79351e969c5832bf60'
    bb.app_id       = 'fd0cd097'
    bb.email        = 'developers@pensionwise.gov.uk'
    bb.password     = 'zZuNFWRD9IqD'
  end
else
  Config.booking_bug = Config::BookingBug.new do |bb|
    bb.environment  = ENV['BOOKING_BUG_ENVIRONMENT']
    bb.company_id   = ENV['BOOKING_BUG_COMPANY_ID']
    bb.api_key      = ENV['BOOKING_BUG_API_KEY']
    bb.app_id       = ENV['BOOKING_BUG_APP_ID']
    bb.email        = ENV['BOOKING_BUG_EMAIL']
    bb.password     = ENV['BOOKING_BUG_PASSWORD']
  end
end
