class BookingBug
  class Filter
    def call(records)
      records.reject do |record|
        Facts::Booking.any?(booking_bug_id: record['id'])
      end
    end
  end
end
