require 'etl/errors'

module ETL
  class AuditLoader
    def initialize(audit_dimension:)
      @audit_dimension = audit_dimension
    end

    def call(records:, log:)
      @audit_dimension.update_attributes!(
        inserted_records: records.count,
        log: log
      )
      { records: records, log: log }
    end
  end
end
