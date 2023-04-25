# frozen_string_literal: true

module Employee
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params
    layout "employee/base"

    def new
      params[:type] == "back" ? build_resource(session[:user_registration]) : build_resource
      yield resource if block_given?
      respond_with resource
    end

    def confirm
      session[:user_registration] = sign_up_params if sign_up_params.present?
      build_resource(session[:user_registration])
      resource.candidate.dob = "#{resource.candidate.year_of_birth}/#{resource.candidate.month_of_birth}/#{resource.candidate.day_of_birth}"

      render_next_step(resource.valid?, "new")
    end

    def create_profile
      session[:user_registration] = sign_up_params if sign_up_params.present?

      build_resource(session[:user_registration])
      resource.candidate.dob = "#{resource.candidate.year_of_birth}/#{resource.candidate.month_of_birth}/#{resource.candidate.day_of_birth}"

      return if resource.errors.blank?

      respond_to do |format|
        format.html { render }
      end
    end

    def create
      build_resource(sign_up_params)

      resource.save
      yield resource if block_given?
      if resource.persisted?
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          CandidateMailer.register_candidate(resource.candidate).deliver_later
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        render "create_profile" # rubocop:disable GitHub/RailsControllerRenderPathsExist
      end
    end

    def complete; end

    # GET /resource/edit
    # def edit
    #   super
    # end

    # PUT /resource
    # def update
    #   superresource_valid
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
      attributes = [:email_confirmation, { candidate_attributes: [:national, :gender, :experiences, :diplomas, :zipcode, :dob,
                                                                  :first_name, :last_name, :first_name_kana, :last_name_kana, :year_of_birth,
                                                                  :month_of_birth, :day_of_birth, :prefecture, :city, :address, :phone_number,
                                                                  :graduation_year, :skill, :specialization, :other_certificates,
                                                                  { attachments_attributes: %i[description file] },
                                                                  { profiles_attributes: %i[year_start_work month_start_work note year_end_work month_end_work] },
                                                                  { certificates: [] }] }]
      devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
    end

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_account_update_params
    #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
    # end

    # The path used after sign up.
    def after_sign_up_path_for(_resource)
      sign_up_complete_path
    end

    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end

    private

    def render_next_step(resource_valid, template_failed)
      key_errors = %w[candidate.graduation_year candidate.specialization candidate.skill candidate.certificates candidate.profiles]
      unless resource_valid
        key_errors.each do |key|
          resource.errors.delete(key) if resource.errors.key?(key)
        end
      end

      if resource.errors.blank?
        respond_to do |format|
          format.html { render }
        end
      else
        render template_failed
      end
    end
  end
end
