module BookingBug
  class Bookings < Base
    def actions
      audit_dimension = build_audit_dimension('Facts::Bookings')

      [
        BookingBugAPI.new(BookingBug.config),
        Filters::IncludeNew.new(db_class: Facts::Booking),
        Transformations::BookingBugBooking.new(audit_dimension: audit_dimension),
        -> { ETL::Loader.new(klass: Facts::Booking) },
        -> { ETL::AuditLoader.new(audit_dimension: audit_dimension) }
      ].map(&:call)
    end
  end
end
