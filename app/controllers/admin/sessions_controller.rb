# frozen_string_literal: true

module Admin
  class SessionsController < Devise::SessionsController
    include Base::BaseFilter
    include Base::LayoutFilter
    include SessionsHelper
    skip_before_action :verify_authenticity_token, only: %i[create destroy] # rubocop:disable Rails/LexicallyScopedActionFilter

    layout "admin/base"
    title_page I18n.t("base.label.admin_login")
    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    def create
      create_session("admin")
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

    def after_sign_out_path_for(_resource_or_scope)
      new_admin_user_session_path
    end

    def after_sign_in_path_for(_resource_or_scope)
      admin_root_path
    end
  end
end
