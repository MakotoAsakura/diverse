# frozen_string_literal: true

module Admin
  class WithholdingSlipsController < AdminController
    include Base::BaseFilter
    include Base::LayoutFilter

    before_action :find_candidate_job, only: %i[show download_pdf send_mail]
    before_action :data_withholding_slip_detail, :set_name_attachment, only: %i[show download_pdf send_mail]

    layout "admin/base"

    def show; end

    def download_pdf
      respond_to do |format|
        # rubocop:disable GitHub/RailsControllerRenderShorthand
        format.pdf do
          render template: "admin/withholding_slips/payslip",
                 pdf: "#{@candidate_job.contract_id}_#{Time.zone.now.strftime('%Y%m%d%H%M%S')}",
                 disposition: "attachment",
                 layout: "pdf",
                 orientation: "Portrait",
                 encoding: "UTF-8"
        end
        # rubocop:enable GitHub/RailsControllerRenderShorthand
      end
    end

    def send_mail
      # rubocop:disable GitHub/RailsControllerRenderShorthand
      render template: "admin/withholding_slips/payslip",
             pdf: @name_attachment,
             layout: "pdf",
             orientation: "Portrait",
             encoding: "UTF-8",
             save_to_file: @name_attachment,
             save_only: true
      # rubocop:enable GitHub/RailsControllerRenderShorthand
      CandidateMailer.send_withholding_slip_pdf(@year, @candidate, @name_attachment).deliver_later
      AdminMailer.send_withholding_slip_pdf(@year, @candidate_job, @candidate, @name_attachment, current_user.manage).deliver_later
      redirect_to withholding_slip_complete_send_mail_admin_candidate_job_path(year: @year)
    end

    def confirm_send_mail
      @year = params[:year].presence || Date.current.year
      @candidate_job = ::CandidateJob.find(params[:id])
      @candidate = @candidate_job.candidate

      raise "403" unless @candidate.user
    end

    def complete_send_mail
      @year = params[:year].presence || Date.current.year
    end

    private

    def find_candidate_job
      @candidate_job = ::CandidateJob.find_by(id: params[:id])
    end

    def data_withholding_slip_detail
      @year = params[:year].presence || Date.current.year
      @candidate = @candidate_job.candidate
      @medical_institution = @candidate_job.job.medical_institution
      @zipcode = @medical_institution.zipcode
      @address = @medical_institution.location
      @name = @medical_institution.name

      @reign_year = @year.to_i - 2019 + 1 # need refactor

      payslips_full_year = Payslip.by_full_year(@year.to_i, @medical_institution.id, @candidate_job.job_id, @candidate_job.candidate_id)

      @total_income_full_year = payslips_full_year.sum(:total)
      @total_income_tax_full_year = payslips_full_year.sum(:personal_income_tax)
    end

    def set_name_attachment
      @name_attachment = "#{@year}_withholding_slip_#{@candidate_job.contract_id}_#{Time.zone.now.strftime('%Y%m%d%H%M%S')}"
    end
  end
end
