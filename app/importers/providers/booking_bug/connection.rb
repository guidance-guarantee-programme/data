require 'faraday'
require 'faraday_middleware'

module Providers
  module BookingBug
    class Connection
      def initialize(config:)
        @config = config
      end

      def auth_token
        conn.post do |req|
          req.url '/api/v1/login'
          req.headers = { 'App-Id' => app_id, 'App-Key' => api_key }
          req.body = credentials
        end.body['auth_token']
      end

      def page(url, auth_token)
        PageWrapper.new(
          conn.get do |req|
            req.url url
            req.params.merge!('include_cancelled' => true, 'per_page' => 100)
            req.headers = { 'App-Id' => app_id, 'App-Key' => api_key, 'Auth-Token' => auth_token }
          end.body
        )
      end

      private

      def conn
        @conn ||= Faraday.new(url: "https://#{@config.domain}") do |builder|
          builder.use Faraday::Response::RaiseError
          builder.use ResponseLogger, Rails.logger
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

        def next_page_url
          self['_links']['next'].try(:[], 'href')
        end
      end
    end
  end
end
