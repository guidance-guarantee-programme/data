module Transformations
  class Appointment
    def initialize(audit_dimension:)
      @audit_dimension = audit_dimension
    end

    def call
      ETL::Transform.new do |transformer|
        transformer.add_field(:audit_dimension, method(:audit_dimension))
        transformer.add_field(:date_dimension, method(:date_dimension))
        transformer.add_field(:state_dimension, method(:state_dimension))
        transformer.add_key_field(:reference_number, method(:reference_number))
        transformer.add_field(:reference_updated_at, method(:reference_updated_at))
      end
    end

    def audit_dimension(_)
      @audit_dimension
    end

    def date_dimension(record)
      Dimensions::Date.find_by!(date: Date.parse(record['datetime']))
    end

    def state_dimension(record)
      booking_status = record['_embedded']['answers'].detect do |answer|
        answer['_embedded']['question']['name'] == 'Booking status'
      end
      state_name = booking_status && booking_status['value'].presence
      state_name ? Dimensions::State.find_by!(name: state_name) : Dimensions::State.find_by!(default: true)
    end

    def reference_number(record)
      record['id']
    end

    def reference_updated_at(record)
      Time.zone.parse(record['updated_at'])
    end
  end
end
