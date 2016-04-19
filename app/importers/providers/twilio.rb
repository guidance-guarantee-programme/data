module Providers
  module Twilio
    autoload :API, 'providers/twilio/api'
    autoload :Calls, 'providers/twilio/calls'
    autoload :Config, 'providers/twilio/config'
    autoload :OfflineData, 'providers/twilio/offline_data'

    class ImplementInClass < StandardError; end

    module_function

    def config
      @config ||= Twilio::Config.new
      yield(@config) if block_given?
      @config
    end

    def call(*args)
      Providers::Twilio::Calls.new.call(*args)
    end
  end
end
