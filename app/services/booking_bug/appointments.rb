# frozen_string_literal: true
module BookingBug
  class Appointments < Base
    MAX_UPDATE_DAYS = 7 # used to limit number of entries queried to determine if an update ahs occurred.

    # rubocop:disable MethodLength, AbcSize
    def actions
      audit_dimension = build_audit_dimension('Facts::Appointments')

      @actions ||= [
        ETL::API.new(
          base_path: "/api/v1/admin/#{BookingBug.config.company_id}/bookings",
          connection: BookingBugConnection.new(config: BookingBug.config)
        ),
        ETL::Filter.new(filter_name: 'Cancelled') do |record|
          !record['is_cancelled']
        end,
        ETL::Filter.new(filter_name: 'Future Dated') do |record|
          Date.parse(record['datetime']) < Time.zone.today
        end,
        ETL::Filter.new(filter_name: 'Existing ID') do |record|
          Facts::Appointment.where(reference_number: record['id']).empty? || # new
            begin # edits
              updated_at = Time.zone.parse(record['updated_at'])
              updated_at > MAX_UPDATE_DAYS.days.ago &&
                Facts::Appointment.where(reference_number: record['id']).where(['reference_updated_at < ?', updated_at])
            end
        end,
        ETL::Transform.new do |t|
          t.add_field(
            :audit_dimension,
            ->(_) { audit_dimension }
          )
          t.add_field(
            :date_dimension,
            ->(record) { Dimensions::Date.find_by!(date: Date.parse(record['datetime'])) }
          )
          t.add_field(
            :state_dimension,
            lambda do |record|
              booking_status = record['_embedded']['answers'].detect do |answer|
                answer['_embedded']['question']['name'] == 'Booking status'
              end
              state_name = booking_status && booking_status['value'].presence
              state_name ? Dimensions::State.find_by!(name: state_name) : Dimensions::State.find_by!(default: true)
            end
          )
          t.add_key_field(:reference_number, ->(record) { record['id'] })
          t.add_field(:reference_updated_at, ->(record) { Time.zone.parse(record['updated_at']) })
        end,
        ETL::Loader.new(klass: Facts::Appointment),
        ETL::AuditLoader.new(audit_dimension: audit_dimension)
      ]
    end
    # rubocop:enable MethodLength, AbcSize
  end
end
