module Config
  def self.included(base)
    base.const_set(:Config, Class.new(::Config::Config))
    base::Config.attributes = base::ATTRIBUTES
    base.cattr_accessor :config
  end

  class Config
    cattr_accessor :attrs

    def self.attributes=(attributes)
      self.attrs = attributes
      attr_accessor(*attributes)
    end

    def initialize
      yield(self) if block_given?
    end

    def attributes
      self.class.attrs
    end
  end
end

BookingBug::ATTRIBUTES = %w(environment company_id api_key app_id email password).freeze
BookingBug.include Config

BookingBug.config = BookingBug::Config.new do |config|
  config.environment = ENV['BOOKING_BUG_ENVIRONMENT']
  config.company_id = ENV['BOOKING_BUG_COMPANY_ID']
  config.api_key = ENV['BOOKING_BUG_API_KEY']
  config.app_id = ENV['BOOKING_BUG_APP_ID']
  config.email = ENV['BOOKING_BUG_EMAIL']
  config.password = ENV['BOOKING_BUG_PASSWORD']
end
