class BookingBug
  class Transform
    def call(records)
      records.map do |record|
        fields_for(record)
      end
    end

    def fields_for(record)
      {
        booked_on: Date.parse(record['datetime']),
        metadata: {
          booking_id: record['id']
        }
      }
    end
  end
end
