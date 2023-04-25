# frozen_string_literal: true

module Medical
  class WithholdingSlipsController < MedicalController
    include Base::BaseFilter
    include Base::LayoutFilter

    before_action :find_candidate_job, only: %i[show download_pdf]
    before_action :data_withholding_slip_detail, only: %i[show download_pdf]

    layout "medical/base"

    def show; end

    def download_pdf
      respond_to do |format|
        # rubocop:disable GitHub/RailsControllerRenderShorthand
        format.pdf do
          render template: "medical/withholding_slips/payslip",
                 pdf: "#{@candidate_job.contract_id}_#{Time.zone.now.strftime('%Y%m%d%H%M%S')}",
                 disposition: "attachment",
                 layout: "pdf",
                 orientation: "Portrait",
                 encoding: "UTF-8"
        end
        # rubocop:enable GitHub/RailsControllerRenderShorthand
      end
    end

    private

    def find_candidate_job
      @candidate_job = ::CandidateJob.find_by(id: params[:id])
    end

    def data_withholding_slip_detail
      @year = params[:year].presence || Date.current.year
      @candidate = @candidate_job.candidate
      @reign_year = @year.to_i - 2019 + 1 # need refactor
      @zipcode = current_medical.zipcode
      @address = current_medical.location
      @name = current_medical.name

      payslips_full_year = Payslip.by_full_year(@year.to_i, current_medical.id, @candidate_job.job_id, @candidate_job.candidate_id)

      @total_income_full_year = payslips_full_year.sum(:total)
      @total_income_tax_full_year = payslips_full_year.sum(:personal_income_tax)
    end
  end
end
