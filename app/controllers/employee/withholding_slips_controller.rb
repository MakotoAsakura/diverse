# frozen_string_literal: true

module Employee
  class WithholdingSlipsController < EmployeeController
    def index
      @medical_institutions = MedicalInstitution.medical_institution_working(current_candidate.id)
                                                .order("candidate_jobs.created_at" => :desc).page(params[:page]).per(10)

      if params[:medical_institution_id].blank? && params[:job_id].blank?
        @medical_institutions = current_candidate.medical_institutions.page(params[:page]).per(10)
        return
      end

      if params[:medical_institution_id].present?
        data_withholding_slip_detail

        if params[:job_id].blank?
          @candidate_jobs = current_candidate.candidate_job_workings.joins(:job)
                                             .where(job: { medical_institution_id: @medical_institution.id })
                                             .order(created_at: :desc).page(params[:page]).per(10)

          render "jobs" # rubocop:disable GitHub/RailsControllerRenderPathsExist
          return
        end
      end

      render_job_detail if params[:job_id].present?
    end

    def download_pdf
      data_withholding_slip_detail

      respond_to do |format|
        # rubocop:disable GitHub/RailsControllerRenderShorthand
        format.pdf do
          render template: "employee/withholding_slips/payslip",
                 pdf: Time.zone.now.strftime("%Y%m%d%H%M%S"),
                 disposition: "attachment",
                 layout: "pdf",
                 orientation: "Portrait",
                 encoding: "UTF-8"
        end
        # rubocop:enable GitHub/RailsControllerRenderShorthand
      end
    end

    private

    def data_withholding_slip_detail
      @medical_institution = MedicalInstitution.find(params[:medical_institution_id])
      @zipcode = @medical_institution.zipcode
      @address = @medical_institution.location
      @name = @medical_institution.name
      @system_setting = SystemSetting.last
      @year = params[:year].presence || Date.current.year
      @reign_year = @year.to_i - 2019 + 1 # need refactor

      payslips_full_year = Payslip.by_full_year(@year.to_i, params[:medical_institution_id], params[:job_id], current_candidate.id)
      @total_income_full_year = payslips_full_year.sum(:total)
      @total_income_tax_full_year = payslips_full_year.sum(:personal_income_tax)
    end

    def render_job_detail
      @medical_institution = MedicalInstitution.find(params[:medical_institution_id])
      @zipcode = @medical_institution.zipcode
      @address = @medical_institution.location
      @name = @medical_institution.name
      @candidate_job = CandidateJob.find_by(candidate_id: current_candidate.id, job_id: params[:job_id])

      @attachments = @candidate_job.attachments.order(created_at: :desc)

      render "job_detail" # rubocop:disable GitHub/RailsControllerRenderPathsExist
    end
  end
end
