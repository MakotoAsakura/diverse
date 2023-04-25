# frozen_string_literal: true

module Employee
  class PayslipsController < EmployeeController
    include Base::BaseFilter
    include Base::CrudFilter

    layout "employee/base"
    model Payslip

    def index
      redirect_to timeline_payslips_path and return unless params[:year] && params[:month]

      @year = params[:year]
      @month = params[:month]
      @items = @model.by_year(@year).by_month(@month).where(candidate_id: current_candidate.id)
      @items.each(&:checked_view)
      @items = @items.page(params[:page]).per(1)
    end

    def timeline
      @system_setting = SystemSetting.last
      @time_lines = current_candidate.payslips.select("year, month, SUM(viewed_date) as viewed").group(%i[year month])
                                     .order(year: :desc).order(month: :desc).page(params[:page]).per(5)
    end

    def download_pdf
      @page = params[:page].presence || 1
      @year = params[:year].presence || Date.current.year
      @month = params[:month].presence || Date.current.month
      @item = current_candidate.payslips.by_year(@year).by_month(@month).page(@page).per(1).first
      @candidate_job = @item.job.candidate_jobs.find_by(candidate: current_candidate)
      name = "#{@year}#{format('%02i', @month)}_payslip_#{@candidate_job&.contract_id}_#{Time.zone.now.strftime('%Y%m%d%H%M%S')}"

      respond_to do |format|
        # rubocop:disable GitHub/RailsControllerRenderShorthand
        format.pdf do
          render template: "shared/payslip/payslip",
                 pdf: name,
                 disposition: "attachment",
                 layout: "pdf",
                 orientation: "Portrait",
                 encoding: "UTF-8"
        end
        # rubocop:enable GitHub/RailsControllerRenderShorthand
      end
    end
  end
end
