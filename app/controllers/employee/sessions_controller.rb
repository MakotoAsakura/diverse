# frozen_string_literal: true

module Employee
  class SessionsController < Devise::SessionsController
    include Base::LayoutFilter
    include SessionsHelper
    layout "employee/base"
    skip_before_action :verify_authenticity_token, only: %i[create destroy] # rubocop:disable Rails/LexicallyScopedActionFilter

    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    def create
      create_session("user")
    end

    # DELETE /resource/sign_out

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end
    protected

    def after_sign_in_path_for(_resource)
      root_path
    end

    def after_sign_out_path_for(_resource_or_scope)
      new_user_session_path
    end
  end
end
