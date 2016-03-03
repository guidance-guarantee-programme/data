class BookingBug
  class Config
    ATTRIBUTES = %w(environment company_id api_key app_id email password).freeze
    attr_accessor(*ATTRIBUTES)

    def initialize
      yield(self) if block_given?
    end

    def attributes
      ATTRIBUTES
    end
  end

  def self.config
    @config ||= BookingBug::Config.new
    yield(@config) if block_given?
    @config
  end
end
