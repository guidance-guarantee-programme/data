require 'csv'
class TwilioAPI
  def initialize(config)
    @config = config
  end

  def call
    if @config.offline?
      TwilioOfflineData
    else
      raise 'implement online mode'
      # ETL::API.new(
      #   base_path: "/api/v1/admin/#{@config.company_id}/bookings",
      #   connection: TwilioConnection.new(config: @config)
      # )
    end
  end
end
