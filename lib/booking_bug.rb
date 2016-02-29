require 'faraday'
require 'faraday_middleware'
require 'json'

class BookingBug
  def call
    transformed
  end

  def extracted
    extractor.call
  end

  def filtered
    filter.call(extracted)
  end

  def transformed
    transformer.call(filtered)
  end

  def extractor
    @api ||= Api.new
  end

  def filter
    @filter ||= Filter.new
  end

  def transformer
    @transform ||= Transform.new
  end
end
