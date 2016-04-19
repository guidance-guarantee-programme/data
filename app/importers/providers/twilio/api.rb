require 'twilio-ruby'

module Providers
  module Twilio
    class API
      def initialize(config)
        @config = config
      end

      def call
        return method(:load_offline) if @config.offline?
        method(:load)
      end

      def load_offline(records:, log:)
        { records: records + Providers::Twilio::OfflineData.load, log: log }
      end

      def load(records:, log:)
        @client = ::Twilio::REST::Client.new(account_sid, auth_token)

        batch = @client.calls.list
        loop do
          records += batch
          batch = batch.next_page
          break if batch.empty?
        end

        { records: records, log: log }
      end

      private

      def auth_token
        @config.auth_token
      end

      def account_sid
        @config.account_sid
      end
    end
  end
end
