# frozen_string_literal: true

module Medical
  class MedicalInstitutionsController < MedicalController
    include Base::BaseFilter
    include Base::CrudFilter
    include Base::LayoutFilter

    layout "admin/base"
    title_page I18n.t("admin.medical_institutions.title.index")
    model MedicalInstitution

    before_action :set_title_page

    def index
      @items = @model.approved.search(params[:s]).page(params[:page]).per(10)
    end

    private

    def fix_params
      if params[:action] && @group_action_new.include?(params[:action])
        { user_attributes: { role: "medical" },
          status: :approved,
          approved_date: Time.current }
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
  end
end
