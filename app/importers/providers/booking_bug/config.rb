module Providers
  module BookingBug
    class Config
      ATTRIBUTES = %w(domain company_id api_key app_id email password).freeze
      attr_accessor(*ATTRIBUTES)

      def initialize
        yield(self) if block_given?
      end

      def attributes
        ATTRIBUTES
      end
    end
  end
end
