module Filters
  class IncludeNew
    def initialize(db_class:)
      @db_class = db_class
    end

    def call
      ETL::Filter.new(filter_name: 'Existing record') do |record|
        new(record)
      end
    end

    def new(record)
      !@db_class.exists?(reference_number: record['id'])
    end
  end
end
