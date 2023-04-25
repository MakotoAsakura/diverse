# frozen_string_literal: true

require File.expand_path("production.rb", __dir__)

Rails.application.configure do
  config.log_level = :debug

  config.action_mailer.default_url_options = { host: "18.178.97.21", protocol: "http" }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    user_name: "apikey",
    password: ENV.fetch("SENDGRID_API_KEY", nil),
    domain: "em6383.diverse-work.com",
    address: "smtp.sendgrid.net",
    port: 587,
    authentication: :plain,
    enable_starttls_auto: true
  }
end
