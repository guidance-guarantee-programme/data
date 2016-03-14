module Filters
  class ExcludeCancelled
    def call
      ETL::Filter.new(filter_name: 'Cancelled') do |record|
        !record['is_cancelled']
      end
    end
  end
end
