# frozen_string_literal: true

module Admin
  module MedicalInstitutions
    module Candidates
      class AccountController < AdminController
        include Base::BaseFilter
        include Base::CrudFilter
        include Base::LayoutFilter

        layout "admin/base"
        title_page I18n.t("admin.medical_institution.candidate.title.index")
        model User

        private

        def set_item
          @item = User.find(params[:candidate_id])
        end
      end
    end
  end
end
