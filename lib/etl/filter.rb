module Etl
  class MissingFilterBlock < StandardError; end
  class Filter
    attr_reader :filter

    def initialize(&block)
      raise MissingFilterBlock unless block_given?
      @filter = block
    end

    def call(records)
      records.select do |record|
        @filter.call(record)
      end
    end
  end
end
