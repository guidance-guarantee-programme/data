module Etl
  class Saver
    def initialize(klass:)
      @klass = klass
      @flatten_metadata = !klass.column_names.include?(:metadata)
    end

    def call(records)
      records.each do |record|
        save(record)
      end
    end

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
