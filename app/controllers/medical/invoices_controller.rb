# frozen_string_literal: true

module Medical
  class InvoicesController < MedicalController
    include Base::BaseFilter
    include Base::CrudFilter

    layout "medical/base"
    model Invoice

    def download_pdf
      set_item
      name = "#{@year}#{format('%02i', @month)}_請求書_#{@medical_institution.name}_#{Time.zone.now.strftime('%Y%m%d%H%M%S')}"
      respond_to do |format|
        # rubocop:disable GitHub/RailsControllerRenderShorthand
        format.pdf do
          render template: "shared/invoice/invoice",
                 pdf: name,
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
      @system_setting = SystemSetting.last
      @medical_institution = current_medical

      @item = current_medical.invoices.by_year(@year).by_month(@month).first
      @payslips = current_medical.payslips.by_year(@year).by_month(@month)
    end
  end
end
