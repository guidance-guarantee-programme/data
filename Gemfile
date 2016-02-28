source 'https://rubygems.org'

ruby '2.3.0'

gem 'rails', '4.2.5.1'
gem 'pg', '~> 0.15'

group :development do
  gem 'rake'
  gem 'rubocop', require: false
  gem 'travis', require: false
end

group :test do
  gem 'cucumber-rails', require: false
end

group :development, :test do
  gem 'rspec-rails'
end
