# frozen_string_literal: true

module Admin
  module MedicalInstitutions
    class CandidatesController < AdminController
      include Base::BaseFilter
      include Base::CrudFilter
      include Base::LayoutFilter

      layout "admin/base"
      title_page I18n.t("admin.medical_institution.candidate.title.index")
      model Candidate

      before_action :set_title_page
      before_action :find_medical_institution, only: :index

      # Screen-AD09
      def index
        medical_institution_id = params[:medical_institution_id]
        @items = @model.select("candidates.*, candidate_jobs.contract_id, candidate_jobs.job_id").joins(:job_workings)
                       .where("jobs.medical_institution" => medical_institution_id)
                       .order("contract_id DESC").search(params[:s]).page(params[:page]).per(10)
      end

      private

      def set_title_page
        if action_name == "complete"
          request_referrer = Rails.application.routes.recognize_path(request.referrer)
          self.class.send(:title_page, I18n.t("admin.medical_institution.#{@model.name.underscore}.title.complete.#{request_referrer[:action]}"))
        else
          self.class.send(:title_page, I18n.t("admin.medical_institution.#{@model.name.underscore}.title.#{action_name}"))
        end
      end

      def find_medical_institution
        @medical_institution = MedicalInstitution.find(params[:medical_institution_id])
      end
    end
  end
end
