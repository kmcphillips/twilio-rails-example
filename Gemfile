source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.4.4"

gem "rails", "~> 7.1.0"
gem "trilogy"
gem "sprockets-rails"
gem "puma", ">= 6.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "redis", "~> 4.0"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem "sidekiq", "~> 7.1"
gem "aws-sdk-s3"
gem "dotenv-rails"
gem "faker"
gem "base64"
gem "bigdecimal"
gem "observer"
gem "ostruct"
gem "benchmark"
gem "irb"
gem "reline"
gem "fiddle"
gem "mutex_m" # Works around LoadError: cannot load such file -- mutex_m
gem "concurrent-ruby", "1.3.4" # Works around uninitialized constant ActiveSupport::LoggerThreadSafeLevel::Logger

gem "twilio-rails", "1.0.1"
# To test against a branch or fork of twilio-rails, uncomment the following line and set the appropriate branch or fork.
# gem "twilio-rails", github: "kmcphillips/twilio-rails", branch: "main"

group :development, :test do
  gem "sqlite3", "~> 1.4"
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "rspec-rails"
end

group :development do
  gem "web-console"
end
