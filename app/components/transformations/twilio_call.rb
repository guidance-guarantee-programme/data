module Transformations
  class TwilioCall
    MINIMUM_CALL_TIME = 10

    def initialize(audit_dimension:)
      @audit_dimension = audit_dimension
    end

    def call
      ETL::Transform.new do |transformer|
        %i(
          audit_dimension date_dimension time_dimension outcome_dimension
          call_time ring_time talk_time cost
        ).each do |field|
          transformer.add_field(field, method(field))
        end
        transformer.add_key_field(:reference_number, method(:reference_number))
      end
    end

    def audit_dimension(_)
      @audit_dimension
    end

    def date_dimension(record)
      Dimensions::Date.find_by!(date: Time.zone.parse(record.start_time).to_date)
    end

    def time_dimension(record)
      start_time = Time.zone.parse(record.start_time).utc
      Dimensions::Time.find_by!(minute_of_day: start_time.hour * 60 + start_time.min)
    end

    def outcome_dimension(record)
      if record.outbound_duration && record.outbound_duration.to_i > MINIMUM_CALL_TIME
        Dimensions::Outcome.forwarded
      else
        Dimensions::Outcome.abandoned
      end
    end

    def call_time(record)
      record.inbound_duration || record.outbound_duration
    end

    def ring_time(record)
      return 0 unless record.inbound_duration
      record.inbound_duration.to_i - record.outbound_duration.to_i
    end

    def talk_time(record)
      record.outbound_duration.to_i
    end

    def cost(record)
      record.outbound_price.to_f + record.inbound_price.to_f
    end

    def reference_number(record)
      record.sid
    end
  end
end
