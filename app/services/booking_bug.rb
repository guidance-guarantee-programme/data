class BookingBug
  def call
    saver.call(transformed)
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
    @api ||= Etl::Api.new(
      base_path: "/api/v1/admin/#{BookingBug.config.company_id}/bookings",
      connection: BookingBugConnection.new(config: BookingBug.config)
    )
  end

  def filter
    @filter ||= Etl::Filter.new do |record|
      Facts::Booking.where(reference_number: record['id']).empty?
    end
  end

  def transformer
    @transform ||= Etl::Transform.new do |t|
      t.add_field(
        :date_dimension,
        ->(record) { Dimensions::DateMultiBuilder.new(Date.parse(record['datetime'])).date_dimensions!.last }
      )
      t.add_metadata(:reference_number, ->(record) { record['id'] })
    end
  end

  def saver
    @saver ||= Etl::Saver.new(klass: Facts::Booking)
  end
end
