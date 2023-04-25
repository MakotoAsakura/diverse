# frozen_string_literal: true

module Admin
  class MedicalInstitutionsController < AdminController
    include Base::BaseFilter
    include Base::CrudFilter
    include Base::LayoutFilter

    layout "admin/base"
    title_page I18n.t("admin.medical_institutions.title.index")
    model MedicalInstitution

    before_action :set_title_page
    before_action :clear_flash, only: %i[complete] # rubocop:disable Rails/LexicallyScopedActionFilter
    after_action :send_mail, only: %i[create update destroy] # rubocop:disable Rails/LexicallyScopedActionFilter

    def index
      @items = @model.joins(:user).approved.created_at_desc.search(params[:s]).page(params[:page]).per(10)
    end

    private

    def fix_params
      before_action_name = Rails.application.routes.recognize_path(request.referrer)[:action]
      base_params = { creator_id: current_user.id,
                      status: :approved,
                      approved_date: Time.current }

      if params[:action] && @group_action_new.include?(params[:action])
        if before_action_name == "edit"
          base_params
        else
          base_params.merge(user_attributes: { password: User.generate_password, role: "medical" })
        end
      else
        super
      end
    end

    def find_params
      params_permit = params.require(:item).permit(permit_fields)
      params_permit[:zipcode] = params_permit[:zipcode_first] + params_permit[:zipcode_last]

      params_permit.to_h.deep_merge(fix_params)
    rescue StandardError
      raise "400"
    end

    def send_mail
      case action_name
      when "create"
        AdminMailer.send(:create_medical, current_user, @item, @item.user.password).deliver_later
        MedicalInstitutionMailer.send(:create_medical, @item, @item.user.password).deliver_later
      when "destroy"
        AdminMailer.send(:destroy_medical, current_user, { user_email: @item.user_email,
                                                           name: @item.name,
                                                           full_name_manager: @item.full_name_manager }).deliver_later
        MedicalInstitutionMailer.send(:destroy_medical, { user_email: @item.user_email,
                                                          name: @item.name,
                                                          full_name_manager: @item.full_name_manager }).deliver_later
      else
        AdminMailer.send("#{action_name}_medical", current_user, @item).deliver_later
        MedicalInstitutionMailer.send("#{action_name}_medical", @item).deliver_later
      end
    end

    def clear_flash
      flash.clear
    end
  end
end
