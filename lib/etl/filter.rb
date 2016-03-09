module ETL
  MissingFilterBlock = Class.new(StandardError)

  class Filter
    def initialize(filter_name: nil, &block)
      @filter_name = filter_name
      raise MissingFilterBlock unless block_given?
      @filter = block
    end

    def call(records:, log:)
      log = log.dup
      filtered_records = records.select do |record|
        @filter.call(record)
      end

      filtered_count = records.count - filtered_records.count
      log[@filter_name || 'filtered'] = filtered_count if filtered_count > 0

      { records: filtered_records, log: log }
    end
  end
end
