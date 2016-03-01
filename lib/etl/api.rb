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

    def call
      bookings = []
      url = @base_path

      while url
        page = @connection.page(url, auth_token)

        bookings += page.data

        url = nil # test with the first page only
        url = page.next_page
      end

      bookings
    end
  end
end
