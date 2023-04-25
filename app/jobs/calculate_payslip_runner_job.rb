# frozen_string_literal: true

class CalculatePayslipRunnerJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    calculate_payslip_runner = CalculatePayslipRunner.where(start_at: DateTime.current.all_month).first

    if calculate_payslip_runner.present?
      logger = Logger.new($stdout)
      logger.info("There already exists a CalculatePayslipRunner at that ran in #{calculate_payslip_runner.start_at.year}/#{calculate_payslip_runner.start_at.month}")
      return
    end

    runner = CalculatePayslipRunner.create(start_at: Time.current)
    CalculatePayslipService.new.perform
    CalculateInvoiceService.new.perform
    runner.update(end_at: Time.current, status: "complete")
  end
end
