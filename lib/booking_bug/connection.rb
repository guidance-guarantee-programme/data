class BookingBug
  class InvalidResponse < StandardError; end

  class Connection
    def login
      parse(
        conn.post do |req|
          req.url '/api/v1/login'
          req.headers['App-Id'] = app_id
          req.headers['App-Key'] = api_key
          req.body = credentials
        end
      )
    end

    def page(url, auth_token)
      parse(
        conn.get do |req|
          req.url url
          req.params['per_page'] = 100
          req.headers['App-Id'] = app_id
          req.headers['App-Key'] = api_key
          req.headers['Auth-Token'] = auth_token
        end
      )
    end

    private

    def parse(response)
      begin
        parsed = JSON.parse(response.body)
      rescue => e
        raise(BookingBug::InvalidResponse, "#{e.message}\n#{response.body}")
      end

      # rubocop:disable GuardClause
      if (200..399).cover?(response.status)
        parsed
      else
        raise(BookingBug::InvalidResponse, parsed['error'] || parsed)
      end
      # rubocop:enable GuardClause
    end

    def conn
      @conn ||= Faraday.new(url: "https://#{ENV['BOOKING_BUG_ENVIRONMENT']}.bookingbug.com")
    end

    def api_key
      ENV['BOOKING_BUG_API_KEY']
    end

    def app_id
      ENV['BOOKING_BUG_APP_ID']
    end

    def credentials
      "email=#{ENV['BOOKING_BUG_EMAIL']}&password=#{ENV['BOOKING_BUG_PASSWORD']}"
    end
  end
end
