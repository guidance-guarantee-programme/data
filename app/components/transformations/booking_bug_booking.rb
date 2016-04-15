module Transformations
  class BookingBugBooking
    def initialize(audit_dimension:)
      @audit_dimension = audit_dimension
    end

    def call
      ETL::Transform.new do |transformer|
        transformer.add_field(:audit_dimension, method(:audit_dimension))
        transformer.add_field(:date_dimension, method(:date_dimension))
        transformer.add_field(:lead_time, method(:lead_time))
        transformer.add_key_field(:reference_number, method(:reference_number))
      end
    end

    def audit_dimension(_)
      @audit_dimension
    end

    def date_dimension(record)
      Dimensions::Date.find_by!(date: Date.parse(record['created_at']))
    end

    def lead_time(record)
      (Time.zone.parse(record['datetime']) - Time.zone.parse(record['created_at'])).to_i
    end

    def reference_number(record)
      record['id']
    end
  end
end
