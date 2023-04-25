# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.1"

# Shim to load environment variables from .env into ENV in development
gem "dotenv-rails"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.1"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use mysql as the database for Active Record
gem "mysql2", "~> 0.5"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Linters
gem "brakeman", require: false
gem "cocoon"
gem "fasterer", require: false
gem "rubocop", require: false
gem "rubocop-github"
gem "rubocop-performance", require: false
gem "rubocop-rails", require: false

gem "devise"
# Use Sass to process CSS
gem "sassc-rails"

gem "unicorn", platform: :ruby

gem "jp_prefecture"

gem "discard", "~> 1.2"

gem "firebase"

# import file
gem "activerecord-import"
gem "roo"

# markdown
gem "redcarpet"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "bcrypt_pbkdf"
  gem "capistrano", "~> 3.10", require: false
  gem "capistrano3-unicorn", require: false
  gem "capistrano-rails", "~> 1.6", require: false
  gem "capistrano-rbenv", "~> 2.2", require: false
  gem "capistrano-sidekiq", require: false
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "ed25519"
  gem "pry-rails"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # Database consistency
  gem "database_consistency", require: false
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

gem "active_decorator"
gem "activerecord-session_store"
gem "bootstrap", "~> 5.1.3"
gem "bootstrap5-kaminari-views"
gem "date_time_attribute"
gem "enum_help"
gem "google-cloud-firestore"
gem "jpostcode"
gem "jquery-rails"
gem "kaminari"
gem "letter_opener_web", "~> 2.0", group: %w[development staging]
gem "ransack", "~> 3.2", ">= 3.2.1"

gem "rubyzip"
# Background processing
gem "sidekiq"
gem "sidekiq-scheduler"
# PDF
gem "image_processing", "~> 1.2"
gem "wicked_pdf"
gem "wkhtmltopdf-binary"

gem "aws-sdk-s3", require: false
gem "bugsnag", "~> 6.24"
