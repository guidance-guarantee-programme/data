require 'date'
require 'populate_date_dimension'

class PopulateDateDimensionJob < ActiveJob::Base
  queue_as :dimension

  def perform(begin_date:, end_date:)
    service = PopulateDateDimension.new(begin_date: Date.parse(begin_date),
                                        end_date: Date.parse(end_date))

    service.call
  end
end
