class BookingBug
  class UnableToAuthenticate < StandardError; end

  class Api
    def initialize(company_id: Config.booking_bug.company_id)
      self.company_id = company_id
      @connection = BookingBug::Connection.new
    end

    def auth_token
      @auth_token ||= @connection.login['auth_token']
    rescue => e
      raise UnableToAuthenticate, e.message
    end

    def call
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

    attr_accessor :company_id

    def base_path
      "/api/v1/admin/#{company_id}/bookings"
    end
  end
end
