module Etl
  class UnableToAuthenticate < StandardError; end

  class Api
    def initialize(base_path:, connection:)
      @base_path = base_path
      @connection = connection
    end

    def auth_token
      @auth_token ||= @connection.auth_token
    rescue => e
      raise UnableToAuthenticate, e.message
    end

    def call(records:, errors:)
      bookings = records.dup
      url = @base_path

      while url
        page = @connection.page(url, auth_token)

        bookings += page.data

        url = page.next_page
      end

      { records: bookings, errors: errors }
    end
  end
end
