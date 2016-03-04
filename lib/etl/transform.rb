module Etl
  class Transform
    def initialize
      @fields = []
      @metadata = []

      yield(self) if block_given?
    end

    def call(records:, errors:)
      errors = errors.dup
      transformed_records = records.map do |record|
        capture_errors(errors) { transform(record) }
      end.compact
      { records: transformed_records, errors: errors }
    end

    def add_field(name, proc)
      @fields << { name: name, proc: proc }
    end

    def add_metadata(name, proc)
      @metadata << { name: name, proc: proc }
    end

    private

    def capture_errors(errors)
      yield
    rescue => e
      error_description = [e.class.to_s, e.message].uniq.compact.join(': ')
      errors[error_description] += 1
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
