module Providers
  module Twilio
    class Config
      OFFLINE = 'offline'.freeze
      ATTRIBUTES = %w(account_sid auth_token mode).freeze

      attr_accessor(*ATTRIBUTES)

      def initialize
        self.mode = OFFLINE
        yield(self) if block_given?
      end

      def attributes
        ATTRIBUTES
      end

      def offline?
        mode == OFFLINE
      end
    end
  end
end
