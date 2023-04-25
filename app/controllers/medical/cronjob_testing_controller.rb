# frozen_string_literal: true

module Medical
  class CronjobTestingController < MedicalController
    include Base::BaseFilter

    layout "medical/base"

    def index; end

    def generate_data
      CalculatePayslipJob.perform_now
      flash[:success] = "Calculate data payslip and data invoice successful" # rubocop:disable Rails/I18nLocaleTexts
      redirect_to medical_cronjob_testing_index_path
    end

    def reset_data
      CalculatePayslipService.new.reset_data
      flash[:success] = "Reset data successful" # rubocop:disable Rails/I18nLocaleTexts
      redirect_to medical_cronjob_testing_index_path
    end
  end
end

# TODO: Run command `rails d controller Medical/CronjobTesting` when deploy source to production
