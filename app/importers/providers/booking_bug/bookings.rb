module Providers
  module BookingBug
    class Bookings < Providers::Base
      def actions
        audit_dimension = build_audit_dimension(fact_table: 'Facts::Bookings', source: 'BookingBug')

        [
          Providers::BookingBug::API.new(Providers::BookingBug.config),
          Filters::IncludeNew.new(db_class: Facts::Booking),
          Transformations::BookingBugBooking.new(audit_dimension: audit_dimension),
          -> { ETL::Loader.new(klass: Facts::Booking) },
          -> { ETL::AuditLoader.new(audit_dimension: audit_dimension) }
        ].map(&:call)
      end
    end
  end
end
