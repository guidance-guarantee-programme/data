require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'features/cassettes'
  c.hook_into :webmock
  c.ignore_request do |req|
    # Don't mock the call that Poltergeist polls while waiting for
    # Phantomjs to load (http://localhost:<random port>/__identify__)
    req.uri =~ %r{/__identify__$}
  end

  %w(BOOKING_BUG_ENVIRONMENT BOOKING_BUG_COMPANY BOOKING_BUG_API_KEY
     BOOKING_BUG_APP_ID BOOKING_BUG_EMAIL BOOKING_BUG_PASSWORD).each do |key|
    c.filter_sensitive_data("<#{key}>") { ENV[key] }
  end
end

VCR.cucumber_tags do |t|
  t.tag '@vcr', use_scenario_name: true
end
