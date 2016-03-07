class BookingBug
  class Config
    ATTRIBUTES = %w(environment company_id api_key app_id email password).freeze
    attr_accessor(*ATTRIBUTES)

    def initialize
      yield(self) if block_given?
    end

    def attributes
      ATTRIBUTES
    end
  end

  def self.config
    @config ||= BookingBug::Config.new
    yield(@config) if block_given?
    @config
  end

  # Allow subset of actions to be run by specifying the number of actions to be performed.
  # Defaults to all actions
  def call(actions_to_perform: actions.count)
    actions[0..actions_to_perform - 1].inject(records: [], log: Hash.new(0)) do |data, action|
      action.call(data)
    end
  end

  # Each 'action' is implemented with an interface which take an input of:
  #   { records: <Array>, errors: Hash.new(0) }
  # and returns a hash in the same format.
  # rubocop:disable MethodLength, AbcSize
  def actions
    @actions ||= [
      Etl::Api.new(
        base_path: "/api/v1/admin/#{BookingBug.config.company_id}/bookings",
        connection: BookingBugConnection.new(config: BookingBug.config)
      ),
      Etl::Filter.new(filter_name: 'Existing ID') do |record|
        Facts::Booking.where(reference_number: record['id']).empty?
      end,
      Etl::Transform.new do |t|
        t.add_field(
          :date_dimension,
          ->(record) { Dimensions::Date.find_by!(date: Date.parse(record['created_at'])) }
        )
        t.add_metadata(:reference_number, ->(record) { record['id'] })
      end,
      Etl::Loader.new(klass: Facts::Booking)
    ]
  end
  # rubocop:enable MethodLength, AbcSize
end
