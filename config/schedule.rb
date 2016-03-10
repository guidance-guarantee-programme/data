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

      every(1.day, 'dimensions.date', at: '00:05') do
        PopulateDateDimensionJob.perform_later(begin_date: Time.zone.yesterday.to_s,
                                               end_date: Time.zone.today.to_s)
      end
    end
  end
end
