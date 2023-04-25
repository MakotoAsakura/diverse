# frozen_string_literal: true

module Employee
  class WorkingMedicalsController < EmployeeController
    def index
      @medical_institutions = MedicalInstitution.approved.medical_institution_working(current_candidate.id)
                                                .order("candidate_jobs.created_at" => :desc).page(params[:page]).per(10)

      if params[:medical_institution_id].blank? && params[:job_id].blank?
        @medical_institutions = current_candidate.medical_institutions.page(params[:page]).per(10)
        return
      end

      if params[:medical_institution_id].present?
        @medical_institution = @medical_institutions.find(params[:medical_institution_id])

        if params[:job_id].blank?
          @candidate_jobs =
            current_candidate.candidate_jobs.recruitment
                             .order(created_at: :desc)
                             .page(params[:page]).per(10)
          render "jobs" # rubocop:disable GitHub/RailsControllerRenderPathsExist
          return
        end
      end

      render_job_detail if params[:job_id].present?
    end

    private

    def render_job_detail
      @medical_institution = MedicalInstitution.find(params[:medical_institution_id])
      @candidate_job = CandidateJob.find_by(candidate_id: current_candidate.id, job_id: params[:job_id])
      raise "404" unless @candidate_job

      @attachments = @candidate_job.attachments.order(created_at: :desc)
      @attachments_of_employee = @attachments.created_by_role("user")

      render "job_detail" # rubocop:disable GitHub/RailsControllerRenderPathsExist
    end
  end
end
