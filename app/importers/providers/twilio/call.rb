module Providers
  module Twilio
    class Call < BookingBug::Base # move this to Importers::Base ??
      def actions
        audit_dimension = build_audit_dimension('Facts::Call')

        [
          TwilioAPI.new(Twilio.config),
          # Filters::IncludeNew.new(db_class: Facts::Call),
          Transformations::TwilioMerge,
          Transformations::TwilioCall.new(audit_dimension: audit_dimension),
        # -> { ETL::Loader.new(klass: Facts::Call) },
        # -> { ETL::AuditLoader.new(audit_dimension: audit_dimension) }
        ].map(&:call)
      end
    end
  end
end
