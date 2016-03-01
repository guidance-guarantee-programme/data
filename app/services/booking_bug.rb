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
      connection: BookingBugConnection.new
    )
  end

  def filter
    @filter ||= Etl::Filter.new do |booking_reference|
      Facts::Booking.exists?(reference_number: booking_reference)
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
