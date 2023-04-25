# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def json_content_type
    browser.ie? && browser.version.to_i <= 9 ? "text/plain" : "application/json"
  end

  before_action :configure_permitted_parameters, if: :devise_controller?

  def set_title_page
    if action_name == "complete"
      url = Rails.application.routes.recognize_path(request.referrer)
      self.class.send(:title_page, I18n.t("admin.#{controller_name}.title.complete.#{url[:action]}"))
    else
      self.class.send(:title_page, I18n.t("admin.#{controller_name}.title.#{action_name}"))
    end
  end

  protected

  def configure_permitted_parameters
    added_attrs = %i[email password password_confirmation remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def disable_turbo
    @__disable_turbo = true
  end
end
