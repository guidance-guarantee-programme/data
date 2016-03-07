source 'https://rubygems.org'

ruby '2.3.0'

gem 'rails', '4.2.5.2'
gem 'pg', '~> 0.15'

gem 'faraday'
gem 'faraday_middleware'

group :development do
  gem 'overcommit', require: false
  gem 'rake'
  gem 'rubocop', require: false
  gem 'travis', require: false
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'vcr'
  gem 'webmock'
end

group :development, :test do
  gem 'pry-rails'
  gem 'dotenv-rails'
  gem 'rspec-rails'
end
