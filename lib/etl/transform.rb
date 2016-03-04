module Etl
  class Transform
    def initialize
      @fields = []
      @metadata = []

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

    def add_metadata(name, proc)
      @metadata << { name: name, proc: proc }
    end

    private

    def log_errors(log)
      yield
    rescue => e
      error_description = [e.class.to_s, e.message].uniq.compact.join(': ')
      log[error_description] += 1
      nil
    end

    def transform(record)
      response = Hash.new { |h, k| h[k] = {} }
      @fields.each { |field| response[field[:name]] = field[:proc].call(record) }
      @metadata.each { |field| response[:metadata][field[:name]] = field[:proc].call(record) }
      response
    end
  end
end
