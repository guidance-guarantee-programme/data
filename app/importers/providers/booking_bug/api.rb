module Providers
  module BookingBug
    class API
      class UnableToAuthenticate < StandardError; end

      def initialize(config)
        @config = config
      end

      def call
        method(:load)
      end

      def load(records:, log:)
        url = "/api/v1/admin/#{@config.company_id}/bookings"
        connection = Providers::BookingBug::Connection.new(config: @config)

        while url
          page = connection.page(url, auth_token(connection))
          records += page.data
          url = page.next_page_url
        end

        { records: records, log: log }
      end

      def auth_token(connection)
        @auth_token ||= connection.auth_token
      rescue => e
        raise UnableToAuthenticate, e.message
      end
    end
  end
end
