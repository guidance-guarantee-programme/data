require 'csv'

module Providers
  module Twilio
    class OfflineData
      class << self
        def csv_path
          Rails.root.join('offline_data/twilio.csv')
        end

        def load(path = csv_path)
          records = []
          CSV.foreach(path, header_converters: :symbol, headers: true) do |row|
            records << new(row)
          end
          populate_parent_sid(records)
          records
        end

        def populate_parent_sid(calls)
          calls.sort_by(&:end_time).group_by(&:from).each do |_from, calls_for_from|
            while calls_for_from.any?
              first, second = *calls_for_from.shift(2)
              if call_pair?(first, second)
                second.parent_call_sid = first.sid
              elsif second
                # push back onto strack so it can be picked up in the next loop
                calls_for_from.unshift(second)
              end
            end
          end
        end

        def call_pair?(first, second)
          second &&
            first.direction != second.direction &&
            (Time.zone.parse(second.end_time) - Time.zone.parse(first.end_time)) <= 1
        end
      end

      attr_accessor :parent_call_sid

      def initialize(hash)
        @hash = hash
      end

      def status
        @hash[:status].downcase.tr(' ', '-')
      end

      def to
        @hash[:to]
      end

      def from
        @hash[:from]
      end

      def sid
        @hash[:sid]
      end

      def direction
        @hash[:direction].downcase.tr(' ', '-')
      end

      def start_time
        @hash[:starttime]
      end

      def end_time
        @hash[:endtime]
      end

      def duration
        @hash[:duration]
      end

      def price
        @hash[:price]
      end
    end
  end
end
