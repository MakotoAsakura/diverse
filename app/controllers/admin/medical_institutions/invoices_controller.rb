# frozen_string_literal: true

module Admin
  module MedicalInstitutions
    class InvoicesController < AdminController
      include Base::BaseFilter
      include Base::CrudFilter

      layout "admin/base"
      model Invoice

      before_action :set_item, :set_name_attachment, only: %i[show download_pdf send_mail]

      def download_pdf
        respond_to do |format|
          # rubocop:disable GitHub/RailsControllerRenderShorthand
          format.pdf do
            render template: "shared/invoice/invoice",
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
        render template: "shared/invoice/invoice",
               pdf: @name_attachment,
               disposition: "attachment",
               layout: "pdf",
               orientation: "Portrait",
               encoding: "UTF-8",
               save_to_file: @name_attachment,
               save_only: true
        # rubocop:enable GitHub/RailsControllerRenderShorthand
        MedicalInstitutionMailer.send_invoice_pdf(@year, @month, @medical_institution, @name_attachment).deliver_later
        AdminMailer.send_invoice_pdf(@year, @month, @medical_institution, @name_attachment, current_user.manage).deliver_later

        redirect_to complete_send_mail_admin_medical_institution_invoices_path
      end

      def confirm_send_mail
        @year = params[:year].presence || Date.current.year
        @month = params[:month].presence || Date.current.month
        @medical_institution = MedicalInstitution.approved.find(params[:medical_institution_id])
        @item = @medical_institution.invoices.by_year(@year).by_month(@month).first
        raise "404" unless @item&.medical_institution&.user
      end

      private

      def set_item
        @year = params[:year].presence || Date.current.year
        @month = params[:month].presence || Date.current.month
        @system_setting = SystemSetting.last
        @medical_institution = MedicalInstitution.approved.find(params[:medical_institution_id])

        @item = @medical_institution.invoices.by_year(@year).by_month(@month).first
        @payslips = @medical_institution.payslips.by_year(@year).by_month(@month)
      end

      def set_name_attachment
        @name_attachment = "#{@year}#{format('%02i', @month)}_請求書_#{@medical_institution.name}_#{Time.zone.now.strftime('%Y%m%d%H%M%S')}"
      end
    end
  end
end
