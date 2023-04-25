# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@diverse-work.com"
  layout "mailer"
end
