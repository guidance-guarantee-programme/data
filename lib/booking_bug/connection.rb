class BookingBug
  class Connection
    def initialize(config: Config.booking_bug)
      @config = config
    end

    def login
      conn.post do |req|
        req.url '/api/v1/login'
        req.headers['App-Id'] = app_id
        req.headers['App-Key'] = api_key
        req.body = credentials
      end.body
    end

    def page(url, auth_token)
      conn.get do |req|
        req.url url
        req.params['per_page'] = 100
        req.headers['App-Id'] = app_id
        req.headers['App-Key'] = api_key
        req.headers['Auth-Token'] = auth_token
      end.body
    end

    private

    def conn
      @conn ||= Faraday.new(url: "https://#{@config.environment}.bookingbug.com") do |builder|
        builder.use Faraday::Response::RaiseError
        builder.use FaradayMiddleware::ParseJson, content_type: /\bjson$/
        builder.adapter Faraday.default_adapter
      end
    end

    def api_key
      @config.api_key
    end

    def app_id
      @config.app_id
    end

    def credentials
      "email=#{@config.email}&password=#{@config.password}"
    end
  end
end
