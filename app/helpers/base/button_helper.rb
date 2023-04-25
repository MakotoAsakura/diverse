# frozen_string_literal: true

module Base
  module ButtonHelper
    def after_complete_button(opts = {})
      referrer_url = request.referrer || request.url
      recognize = Rails.application.routes.recognize_path(referrer_url)

      link_to back_list_url, class: opts[:class] || "button btn-submit" do
        button_tag t("base.buttons.go_to.#{recognize[:controller]}"), class: ""
      end
    end

    def back_list_url
      referrer_url = request.referrer || request.url
      recognize = Rails.application.routes.recognize_path(referrer_url)

      return referrer_url if recognize[:action] == "index"

      recognize[:action] = "index"
      Rails.application.routes.path_for(recognize.slice(:controller, :action))
    rescue ActionController::RoutingError, ActionController::UrlGenerationError
      scope = controller.class.module_parent.name.demodulize.underscore
      scope == "employee" ? root_url : "#{scope}_root_url"
    end
  end
end
