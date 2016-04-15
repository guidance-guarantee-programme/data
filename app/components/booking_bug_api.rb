class BookingBugAPI
  def initialize(config)
    @config = config
  end

  def call
    ETL::API.new(
      base_path: "/api/v1/admin/#{@config.company_id}/bookings",
      connection: BookingBugConnection.new(config: @config)
    )
  end
end
