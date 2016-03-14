module BookingBug
  class ImplementInClass < StandardError; end

  module_function

  def config
    @config ||= BookingBug::Config.new
    yield(@config) if block_given?
    @config
  end

  def call(*args)
    BookingBug::Bookings.new.call(*args)
    BookingBug::Appointments.new.call(*args)
  end
end
