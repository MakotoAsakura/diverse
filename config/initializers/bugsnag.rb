# frozen_string_literal: true

if Rails.env.production? || Rails.env.staging?
  Bugsnag.configure do |config|
    config.api_key = ENV.fetch("BUGSNAG_API", "")
  end
end
