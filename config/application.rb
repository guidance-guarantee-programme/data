require_relative './boot'

require 'rails'
require 'active_record/railtie'

Bundler.require(*Rails.groups)

module PensionWise
  module Data
    class Application < Rails::Application
      # Do not swallow errors in after_commit/after_rollback callbacks.
      config.active_record.raise_in_transactional_callbacks = true
    end
  end
end
