module Providers
  module BookingBug
    autoload :API, 'providers/booking_bug/api'
    autoload :Appointments, 'providers/booking_bug/appointments'
    autoload :Bookings, 'providers/booking_bug/bookings'
    autoload :Config, 'providers/booking_bug/config'
    autoload :Connection, 'providers/booking_bug/connection'

    class ImplementInClass < StandardError; end

    module_function

    def config
      @config ||= BookingBug::Config.new
      yield(@config) if block_given?
      @config
    end

    def call(*args)
      Providers::BookingBug::Bookings.new.call(*args)
      Providers::BookingBug::Appointments.new.call(*args)
    end
  end
end
