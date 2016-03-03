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
    actions[0..actions_to_perform - 1].inject([]) do |data, action|
      action[:method].call(data)
    end
  end

  # rubocop:disable MethodLength
  def actions
    [
      {
        type: :extract,
        method: Etl::Api.new(
          base_path: "/api/v1/admin/#{BookingBug.config.company_id}/bookings",
          connection: BookingBugConnection.new(config: BookingBug.config)
        )
      },
      {
        type: :filter,
        method: Etl::Filter.new { |record| Facts::Booking.where(reference_number: record['id']).empty? }
      }
    ]
  end
  # rubocop:enable MethodLength
end
