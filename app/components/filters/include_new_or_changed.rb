module Filters
  class IncludeNewOrChanged < Filters::IncludeNew
    MAX_UPDATE_DAYS = 7 # used to limit number of entries queried to determine if an update ahs occurred.

    def call
      ETL::Filter.new(filter_name: 'Existing/Unchanged record') do |record|
        new(record) || changed(record)
      end
    end

    def changed(record)
      updated_at = Time.zone.parse(record['updated_at'])
      updated_at > MAX_UPDATE_DAYS.days.ago &&
        @db_class.exists?(['reference_number = ? and reference_updated_at < ?', record['id'], updated_at])
    end
  end
end
