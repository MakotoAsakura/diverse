# frozen_string_literal: true

module Admin
  class PharmaceuticalCompaniesController < AdminController
    include Base::BaseFilter
    include Base::CrudFilter
    include Base::LayoutFilter

    layout "admin/base"
    title_page I18n.t("admin.pharmaceutical_companies.title.index")
    model PharmaceuticalCompany

    def index
      @items = @model.joins(:medical_institution).where(medical_institution: { status: "approved" })
                     .created_at_desc.search(params[:s]).page(params[:page]).per(10)
    end
  end
end
