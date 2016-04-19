module Transformations
  class TwilioMerge
    include ETL::Errors

    class InvalidCallPairs < StandardError; end
    class MultipleCallsForDirection < StandardError; end

    MIN_VALID_CALL_TIME = 5

    def self.call
      new
    end

    def call(records:, log:)
      { records: merge_calls(records, log), log: log }
    end

    def merge_calls(records, log)
      # calls should occur as pairs of inbound and outbound where outbound.parent_call_sid == inbound.sid
      grouped_calls = records.sort_by(&:start_time).group_by { |record| record.parent_call_sid || record.sid }

      grouped_calls.values.map do |calls|
        log_errors(log) { created_merged_call(calls) }
      end
    end

    def created_merged_call(calls)
      raise InvalidCallPairs, "#{calls.count} when maximum of 2 expected" if calls.count > 2
      Record.new(calls)
    end

    class Record
      def initialize(calls)
        @inbound_call = call_for_direction(calls, 'inbound')
        @outbound_call = call_for_direction(calls, 'outbound-dial')
      end

      def [](val)
        send(val)
      end

      delegate :sattus, :from, :sid, :date_created, :date_updated, :start_time, :end_time,
               to: :call

      def twilio_number
        @inbound_call&.to
      end

      def cab_number
        @outbound_call&.to
      end

      def inbound_price
        @inbound_call&.price
      end

      def outbound_price
        @inbound_call&.price
      end

      def inbound_duration
        @inbound_call&.duration
      end

      def outbound_duration
        @outbound_call&.duration
      end

      private

      def call
        @inbound_call || @outbound_call
      end

      def call_for_direction(calls, direction)
        filtered_calls = calls.select { |call| call.direction == direction }
        raise MultipleCallsForDirection, direction if filtered_calls.count > 1
        filtered_calls.first
      end
    end
  end
end
