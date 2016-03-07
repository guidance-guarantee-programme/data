require 'etl/errors'

module Etl
  class LogSaver
    def initialize(importer:)
      @importer = importer
    end

    def call(records:, log:)
      Import.create!(
        importer: @importer,
        inserted_records: records.count,
        log: log
      )
      { records: records, log: log }
    end
  end
end
