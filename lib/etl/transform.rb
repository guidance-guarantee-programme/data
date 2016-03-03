module Etl
  class Transform
    def initialize
      @fields = []
      @metadata = []

      yield(self) if block_given?
    end

    def call(records)
      records.map do |record|
        transform(record)
      end
    end

    def add_field(name, proc)
      @fields << { name: name, proc: proc }
    end

    def add_metadata(name, proc)
      @metadata << { name: name, proc: proc }
    end

    private

    def transform(record)
      response = Hash.new { |h, k| h[k] = {} }
      @fields.each { |field| response[field[:name]] = field[:proc].call(record) }
      @metadata.each { |field| response[:metadata][field[:name]] = field[:proc].call(record) }
      response
    end
  end
end
