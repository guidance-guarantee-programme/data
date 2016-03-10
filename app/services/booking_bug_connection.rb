require 'faraday'
require 'faraday_middleware'

class BookingBugConnection
  def initialize(config:)
    @config = config
  end

  def auth_token
    conn.post do |req|
      req.url '/api/v1/login'
      req.headers['App-Id'] = app_id
      req.headers['App-Key'] = api_key
      req.body = credentials
    end.body['auth_token']
  end

  def page(url, auth_token)
    PageWrapper.new(
      conn.get do |req|
        req.url url
        req.params['per_page'] = 100
        req.params['include_cancelled'] = true
        req.headers['App-Id'] = app_id
        req.headers['App-Key'] = api_key
        req.headers['Auth-Token'] = auth_token
      end.body
    )
  end

  private

  def conn
    @conn ||= Faraday.new(url: "https://#{@config.domain}") do |builder|
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

  class PageWrapper < SimpleDelegator
    def data
      self['_embedded']['bookings']
    end

    def next_page
      self['_links']['next'].try(:[], 'href')
    end
  end
end
