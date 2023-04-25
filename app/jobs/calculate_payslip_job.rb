# frozen_string_literal: true

class CalculatePayslipJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    logger = Logger.new($stdout)
    date_current = DateTime.current
    current_day = date_current.day
    year = date_current.year
    month = date_current.month
    @system_setting = SystemSetting.last
    day = @system_setting.settlement_date_value

    return if current_day != day

    logger.info("CalculatePayslipJob run at: #{date_current}")

    hour = @system_setting.settlement_hour.hour
    min = @system_setting.settlement_hour.min

    CalculatePayslipRunnerJob.set(wait_until: DateTime.new(year, month, day, hour, min).in_time_zone).perform_later

    # CalculatePayslipRunnerJob.perform_now
  end
end
