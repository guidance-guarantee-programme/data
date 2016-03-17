# frozen_string_literal: true
module BookingBug
  class Appointments < Base
    def actions
      audit_dimension = build_audit_dimension('Facts::Appointments')

      [
        BookingBugAPI.new(BookingBug.config),
        Filters::ExcludeCancelled.new,
        Filters::IncludeNewOrChanged.new(db_class: Facts::Appointment),
        Transformations::BookingBugAppointment.new(audit_dimension: audit_dimension),
        -> { ETL::Loader.new(klass: Facts::Appointment) },
        -> { ETL::AuditLoader.new(audit_dimension: audit_dimension) }
      ].map(&:call)
    end
  end
end
