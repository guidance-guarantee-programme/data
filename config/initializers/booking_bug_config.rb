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

Config.booking_bug = Config::BookingBug.new do |config|
  config.environment = ENV['BOOKING_BUG_ENVIRONMENT']
  config.company_id = ENV['BOOKING_BUG_COMPANY_ID']
  config.api_key = ENV['BOOKING_BUG_API_KEY']
  config.app_id = ENV['BOOKING_BUG_APP_ID']
  config.email = ENV['BOOKING_BUG_EMAIL']
  config.password = ENV['BOOKING_BUG_PASSWORD']
end
