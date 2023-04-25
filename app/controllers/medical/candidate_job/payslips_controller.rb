# frozen_string_literal: true

module Medical
  module CandidateJob
    class PayslipsController < MedicalController
      include Base::BaseFilter
      include Base::CrudFilter

      layout "medical/base"
      model ::CandidateJob

      before_action :set_item, :set_name_attachment, only: %i[show download_pdf]

      def download_pdf
        respond_to do |format|
          # rubocop:disable GitHub/RailsControllerRenderShorthand
          format.pdf do
            render template: "shared/payslip/payslip",
                   pdf: @name_attachment,
                   disposition: "attachment",
                   layout: "pdf",
                   orientation: "Portrait",
                   encoding: "UTF-8"
          end
          # rubocop:enable GitHub/RailsControllerRenderShorthand
        end
      end

      private

      def set_item
        @year = params[:year].presence || Date.current.year
        @month = params[:month].presence || Date.current.month

        @candidate_job = @model.find(params[:candidate_job_id])
        @candidate = @candidate_job.candidate
        @item = @candidate.payslips.by_year(@year).by_month(@month).where(job: @candidate_job.job).first
      end

      def set_name_attachment
        @name_attachment = "#{@year}#{format('%02i', @month)}_payslip_#{@candidate_job.contract_id}_#{Time.zone.now.strftime('%Y%m%d%H%M%S')}"
      end
    end
  end
end
