require 'faraday'
require 'json'

require 'booking_bug/api'
require 'booking_bug/connection'

class BookingBug
  def bookings
    api.all
  end

  def api
    @api ||= Api.new
  end
end
