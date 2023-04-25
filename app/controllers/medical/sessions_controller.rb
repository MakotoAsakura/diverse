# frozen_string_literal: true

module Medical
  class SessionsController < Devise::SessionsController
    include Base::BaseFilter
    include Base::LayoutFilter
    include SessionsHelper

    skip_before_action :verify_authenticity_token, only: %i[create destroy] # rubocop:disable Rails/LexicallyScopedActionFilter
    layout "medical/base"
    title_page I18n.t("base.label.login")
    # GET /resource/sign_in
    def new
      @medical_login = true
      super
    end

    # POST /resource/sign_in
    def create
      @medical_login = true
      create_session("medical")
    end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end
    protected

    def after_sign_in_path_for(_resource)
      medical_root_path
    end

    def after_sign_out_path_for(_resource_or_scope)
      new_medical_user_session_path
    end
  end
end
