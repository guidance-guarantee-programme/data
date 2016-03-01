module Etl
  class Filter
    def initialize(&block)
      raise 'Missing filter block' unless block_given?
      @filter_block = block
    end

    def call(records)
      records.reject do |record|
        @filter_block.call(record['id'])
      end
    end
  end
end
