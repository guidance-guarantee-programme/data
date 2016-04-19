module Filters
  class IncludeNew
    def initialize(db_class:, key: 'id')
      @db_class = db_class
      @key = key
    end

    def call
      ETL::Filter.new(filter_name: 'Existing record') do |record|
        new(record)
      end
    end

    def new(record)
      !@db_class.exists?(reference_number: record[@key])
    end
  end
end
