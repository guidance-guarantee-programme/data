require 'etl/errors'

module ETL
  class Transform
    include ETL::Errors

    def initialize
      @fields = []
      @keys = []

      yield(self) if block_given?
    end

    def call(records:, log:)
      log = log.dup
      transformed_records = records.map do |record|
        log_errors(log) { transform(record) }
      end.compact
      { records: transformed_records, log: log }
    end

    def add_field(name, proc)
      @fields << { name: name, proc: proc }
    end

    def add_key_field(name, proc)
      @keys << { name: name, proc: proc }
    end

    private

    def transform(record)
      response = Hash.new { |h, k| h[k] = {} }
      @fields.each { |field| response[:data][field[:name]] = field[:proc].call(record) }
      @keys.each { |field| response[:keys][field[:name]] = field[:proc].call(record) }
      response
    end
  end
end
