require 'etl/errors'

module Etl
  class Loader
    include Etl::Errors

    def initialize(klass:)
      @klass = klass
      @flatten_metadata = !klass.column_names.include?(:metadata)
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
      if @flatten_metadata
        data = record.dup
        metadata = data.delete(:metadata)
        @klass.create!(data.merge(metadata))
      else
        @klass.create!(record)
      end
    end
  end
end
