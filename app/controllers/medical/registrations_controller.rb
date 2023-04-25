# frozen_string_literal: true

module Medical
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params
    include Base::BaseFilter
    include Base::LayoutFilter
    include SessionsHelper

    layout "medical/base"
    title_page I18n.t("base.label.login")

    model User

    def confirm
      session[:user_registration] = sign_up_params if sign_up_params.present?
      build_resource(session[:user_registration])

      if resource.valid?
        respond_to do |format|
          format.html { render }
        end
      else
        render "new" # rubocop:disable GitHub/RailsControllerRenderPathsExist
      end
    end

    def create
      build_resource(session[:user_registration])
      resource.role = "medical"

      resource.save
      yield resource if block_given?
      if resource.persisted?
        if resource.active_for_authentication?
          delete_session
          AdminMailer.register_medical(Manage.joins(:user).pluck(:email), resource.medical_institution).deliver_later
          MedicalInstitutionMailer.register_medical(resource.medical_institution).deliver_later
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    end

    def complete; end

    # GET /resource/edit
    # def edit
    #   super
    # end

    # DELETE /resource
    # def destroy
    #   super
    # end

    # GET /resource/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the user wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.
    # def cancel
    #   super
    # end

    protected

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_up_params
      attributes = [:email_confirmation, { medical_institution_attributes: [:name, :name_kana, :phone_number, :url, :zipcode_first,
                                                                            :zipcode_last, :location, :first_name_manager, :last_name_manager,
                                                                            :first_name_kana_manager, :last_name_kana_manager,
                                                                            { pharmaceutical_company_attributes: %i[name staff_ms] }] }]
      devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
    end

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_account_update_params
    #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
    # end

    # The path used after sign up.
    def after_sign_up_path_for(_resource)
      medical_sign_up_complete_path
    end

    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end

    private

    def delete_session
      session.delete(:user_registration) if session[:user_registration]
    end
  end
end
