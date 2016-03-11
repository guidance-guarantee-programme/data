module BookingBug
  class Bookings < Base
    # rubocop:disable MethodLength, AbcSize
    def actions
      audit_dimension = build_audit_dimension('Facts::Bookings')

      @actions ||= [
        ETL::API.new(
          base_path: "/api/v1/admin/#{BookingBug.config.company_id}/bookings",
          connection: BookingBugConnection.new(config: BookingBug.config)
        ),
        ETL::Filter.new(filter_name: 'Existing ID') do |record|
          Facts::Booking.where(reference_number: record['id']).empty?
        end,
        ETL::Transform.new do |t|
          t.add_field(
            :audit_dimension,
            ->(_) { audit_dimension }
          )
          t.add_field(
            :date_dimension,
            ->(record) { Dimensions::Date.find_by!(date: Date.parse(record['created_at'])) }
          )
          t.add_key_field(:reference_number, ->(record) { record['id'] })
        end,
        ETL::Loader.new(klass: Facts::Booking),
        ETL::AuditLoader.new(audit_dimension: audit_dimension)
      ]
    end
    # rubocop:enable MethodLength, AbcSize
  end
end
