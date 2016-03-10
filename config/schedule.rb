require_relative './boot'
require_relative './environment'

module PensionWise
  module Data
    module Schedule
      include Clockwork

      configure do |config|
        config[:sleep_timeout] = 60
        config[:tz] = 'UTC'
      end

      error_handler do |error|
        Bugsnag.notify_or_ignore(error)
      end
    end
  end
end
