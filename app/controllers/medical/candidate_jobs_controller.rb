# frozen_string_literal: true

require "zip"

module Medical
  class CandidateJobsController < MedicalController
    include Base::BaseFilter
    include Base::CrudFilter

    layout "medical/base"
    model ::CandidateJob

    before_action :set_items, only: %i[index download_batch download_withholding_slips]
    before_action :find_system_settings, only: %i[download_withholding_slips]

    def index
      flash.each { |key, _| flash.clear if key != :danger }

      @q = @items.ransack(params[:q])
      @items = @q.result.order(created_at: :desc).page(params[:page]).per(10)
    end

    def download_batch
      @files = []
      month_picker = params[:item][:start_at]
      year = begin
        month_picker.split("-")[0]
      rescue StandardError
        nil
      end
      month = begin
        month_picker.split("-")[1]
      rescue StandardError
        nil
      end

      if year.blank? || month.blank?
        flash[:danger] = I18n.t("base.flash_message.input_date")
        redirect_to medical_candidate_jobs_path and return
      end

      if @items.blank?
        flash[:danger] = I18n.t("base.flash_message.not_found_data")
        redirect_to medical_candidate_jobs_path and return
      end

      @items.order(created_at: :desc).each do |item|
        candidate = item.candidate
        @item = candidate.payslips.by_year(year).by_month(month).where(job: item.job).first
        next unless @item

        @candidate_job = @item.job.candidate_jobs.find_by(candidate: candidate)
        name = "#{@item.year}#{format('%02i', @item.month)}_payslip_#{@candidate_job.contract_id}_#{Time.zone.now.strftime('%Y%m%d%H%M%S')}.pdf"
        # rubocop:disable GitHub/RailsControllerRenderShorthand
        render template: "shared/payslip/payslip",
               pdf: name,
               layout: "pdf",
               orientation: "Portrait",
               encoding: "UTF-8",
               save_to_file: name,
               save_only: true
        # rubocop:enable GitHub/RailsControllerRenderShorthand
        @files << name
      end

      if @files.blank?
        flash[:danger] = I18n.t("base.flash_message.not_found_data")
        redirect_to medical_candidate_jobs_path(start_at: Time.zone.local(year, month)) and return
      end

      @filename = "#{year}_#{month}_#{current_medical.name}_#{Time.zone.now.strftime('%Y%m%d%H%M%S')}.zip"
      download_zip_file
    end

    def download_withholding_slips
      @files = []
      @year = params[:item][:start_at]
      @reign_year = @year.to_i - 2019 + 1 # need refactor
      @zipcode = current_medical.zipcode
      @address = current_medical.location
      @name = current_medical.name

      if @year.blank?
        flash[:danger] = I18n.t("base.flash_message.input_date")
        redirect_to medical_candidate_jobs_path and return
      end

      if @items.blank?
        flash[:danger] = I18n.t("base.flash_message.not_found_data")
        redirect_to medical_candidate_jobs_path and return
      end

      @items.order(created_at: :desc).each do |item|
        payslips_full_year = Payslip.by_full_year(@year.to_i, current_medical.id, item.job_id, item.candidate_id)
        next unless payslips_full_year

        @total_income_full_year = payslips_full_year.sum(:total)
        @total_income_tax_full_year = payslips_full_year.sum(:personal_income_tax)

        name = Rails.root.join("#{item.contract_id}_#{Time.zone.now.strftime('%Y%m%d%H%M%S')}.pdf")
        # rubocop:disable GitHub/RailsControllerRenderShorthand
        render template: "employee/withholding_slips/payslip",
               locals: { current_candidate: item.candidate },
               pdf: Time.zone.now.strftime("%Y%m%d%H%M%S"),
               layout: "pdf",
               orientation: "Portrait",
               encoding: "UTF-8",
               save_to_file: name,
               save_only: true
        # rubocop:enable GitHub/RailsControllerRenderShorthand
        @files << name
      end

      @filename = "#{@year}_#{current_medical.name}_#{Time.zone.now.strftime('%Y%m%d%H%M%S')}.zip"
      download_zip_file
    end

    private

    def find_system_settings
      @system_setting = SystemSetting.last
    end

    def download_zip_file
      flash.clear
      temp_file = Tempfile.new(@filename)
      begin
        @files.each do |file|
          Zip::File.open(temp_file.path, Zip::File::CREATE) do |zip|
            zip.add(File.basename(file), file)
          end
        end

        send_data(File.binread(temp_file.path), type: "application/zip", disposition: "attachment", filename: @filename)
      ensure
        temp_file.close
        temp_file.unlink
      end

      remove_files(@files)
    end

    def set_items
      @items = @model.joins(:job).recruitment.where("jobs.medical_institution_id" => current_medical.id)
    end

    def remove_files(files)
      files.each do |file|
        File.delete(file) if File.exist?(file)
      end
    end
  end
end
