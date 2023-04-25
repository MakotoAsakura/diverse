# frozen_string_literal: true

module Medical
  class MedicalController < ApplicationController
    include MedicalHelper

    before_action :authenticate_medical_user!
    helper_method :current_medical
    before_action :messages_unseen

    def current_user
      current_medical_user
    end

    def current_medical
      return unless current_user

      current_user.medical_institution
    end

    def set_title_page
      if action_name == "complete"
        url = Rails.application.routes.recognize_path(request.referrer)
        self.class.send(:title_page, I18n.t("medical.#{controller_name}.title.complete.#{url[:action]}"))
      else
        self.class.send(:title_page, I18n.t("medical.#{controller_name}.title.#{action_name}"))
      end
    end

    def authenticate_medical_user!
      session[:return_to] = request.original_url unless current_user

      super
    end

    def messages_unseen
      @total_messages_unseen = total_messages_unseen
    end
  end
end
