source "https://rubygems.org"

gem "rails", "~> 7.2.2", ">= 7.2.2.1"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"

# Auth
gem "bcrypt", "~> 3.1.7"
gem "jwt", "~> 2.7"

# Real-time
gem "redis", "~> 5.0"
gem "actioncable"

# Background jobs
gem "sidekiq", "~> 7.2"

# HTTP requests (YouTube metadata via noembed)
gem "httparty", "~> 0.21"

# Pagination
gem "pagy", "~> 6.1"

# CORS
gem "rack-cors", "~> 2.0"

gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "rspec-rails", "~> 6.1"
  gem "factory_bot_rails", "~> 6.4"
  gem "faker", "~> 3.2"
  gem "shoulda-matchers", "~> 5.3"
  gem "database_cleaner-active_record", "~> 2.1"
end

group :development do
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :test do
  gem "webmock", "~> 3.23"
end
