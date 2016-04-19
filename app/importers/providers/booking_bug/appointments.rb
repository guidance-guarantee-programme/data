# frozen_string_literal: true
module Providers
  module BookingBug
    class Appointments < Providers::Base
      def actions
        audit_dimension = build_audit_dimension(fact_table: 'Facts::Appointments', source: 'BookingBug')

        [
          Providers::BookingBug::API.new(Providers::BookingBug.config),
          Filters::ExcludeCancelled.new,
          Filters::IncludeNewOrChanged.new(db_class: Facts::Appointment),
          Transformations::BookingBugAppointment.new(audit_dimension: audit_dimension),
          -> { ETL::Loader.new(klass: Facts::Appointment) },
          -> { ETL::AuditLoader.new(audit_dimension: audit_dimension) }
        ].map(&:call)
      end
    end
  end
end
