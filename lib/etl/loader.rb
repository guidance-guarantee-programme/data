require 'etl/errors'

module Etl
  class Loader
    include Etl::Errors

    def initialize(klass:)
      @klass = klass
    end

    def call(records:, log:)
      log = log.dup
      saved_records = records.map do |record|
        log_errors(log) { save(record) }
      end.compact
      { records: saved_records, log: log }
    end

    private

    def save(record)
      data = record[:data]
      keys = record[:keys]
      if (record = @klass.find_by(keys)) # check for existing record
        record.update_attributes!(data)
      else
        @klass.create!(data.merge(keys))
      end
    end
  end
end
