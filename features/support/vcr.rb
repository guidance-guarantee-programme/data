require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'features/cassettes'
  c.hook_into :webmock

  Config.booking_bug.attributes.each do |attr|
    c.filter_sensitive_data("<BOOKING_BUG_#{attr.upcase}>") { Config.booking_bug.send(attr) }
  end
end

VCR.cucumber_tags do |t|
  t.tag '@vcr', use_scenario_name: true
  t.tag '@vcr_booking_bug_all'
end
