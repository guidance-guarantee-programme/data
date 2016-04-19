module Providers
  module Twilio
    class Calls < Providers::Base
      def actions
        audit_dimension = build_audit_dimension(fact_table: 'Facts::Call', source: 'Twilio')

        [
          Providers::Twilio::API.new(Providers::Twilio.config),
          Transformations::TwilioMerge,
          Filters::IncludeNew.new(db_class: Facts::Call, key: :sid),
          Transformations::TwilioCall.new(audit_dimension: audit_dimension),
          -> { ETL::Loader.new(klass: Facts::Call) },
          -> { ETL::AuditLoader.new(audit_dimension: audit_dimension) }
        ].map(&:call)
      end
    end
  end
end
