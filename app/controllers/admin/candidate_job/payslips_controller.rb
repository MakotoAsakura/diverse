# frozen_string_literal: true

module Admin
  module CandidateJob
    class PayslipsController < AdminController
      include Base::BaseFilter
      include Base::CrudFilter

      layout "admin/base"
      model ::CandidateJob

      before_action :set_item, :set_name_attachment, only: %i[show download_pdf send_mail]

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

      def send_mail
        # rubocop:disable GitHub/RailsControllerRenderShorthand
        render template: "shared/payslip/payslip",
               pdf: @name_attachment,
               layout: "pdf",
               orientation: "Portrait",
               encoding: "UTF-8",
               save_to_file: @name_attachment,
               save_only: true
        # rubocop:enable GitHub/RailsControllerRenderShorthand
        CandidateMailer.send_payslip_pdf(@year, @month, @candidate, @name_attachment).deliver_later
        AdminMailer.send_payslip_pdf(@year, @month, @candidate_job, @candidate, @name_attachment, current_user.manage).deliver_later

        redirect_to complete_send_mail_admin_candidate_job_payslip_path(year: @year, month: @month)
      end

      def confirm_send_mail
        @year = params[:year].presence || Date.current.year
        @month = params[:month].presence || Date.current.month
        @candidate_job = @model.find(params[:candidate_job_id])
        @candidate = @candidate_job.candidate

        raise "403" unless @candidate.user
      end

      def complete_send_mail
        @year = params[:year].presence || Date.current.year
        @month = params[:month].presence || Date.current.month
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
