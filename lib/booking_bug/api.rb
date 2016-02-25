class BookingBug
  class UnableToAuthenticate < StandardError; end

  class Api
    def initialize
      @connection = BookingBug::Connection.new
    end

    def auth_token
      @auth_token ||= @connection.login['auth_token']
    rescue => e
      raise UnableToAuthenticate, e.message
    end

    def all
      bookings = []
      url = base_path

      while url
        data = @connection.page(url, auth_token)

        bookings += data['_embedded']['bookings']

        # TODO: replace the below with try once we have active-support!
        url = data['_links']['next'] && data['_links']['next']['href']
      end

      bookings
    end

    private

    def base_path
      "/api/v1/admin/#{ENV['BOOKING_BUG_COMPANY']}/bookings"
    end
  end
end
