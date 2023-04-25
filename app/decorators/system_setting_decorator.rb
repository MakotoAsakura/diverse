# frozen_string_literal: true

module SystemSettingDecorator
  def display_settlement_expiration_date
    format_settlement_expiration_date == "end_of_month" ? I18n.t("system_settings.options.end_of_month") : "#{format_settlement_expiration_date}日"
  end

  def display_settlement_date
    format_settlement_date == "end_of_month" ? I18n.t("system_settings.options.end_of_month") : "#{format_settlement_date}日"
  end

  def display_payment_due_date
    format_payment_due_date == "end_of_month" ? I18n.t("system_settings.options.end_of_month") : "#{format_payment_due_date}日"
  end

  def display_current_payment_due_date
    current_payment_due_date
  end

  def display_system_fee
    "#{system_fee}%"
  end

  def display_pharmaceutical_introduction_fee
    "#{pharmaceutical_introduction_fee}%"
  end

  def display_job_acceptance_waiting_alert
    "#{job_acceptance_waiting_alert}日"
  end

  def display_time_approval_waiting_alert
    "#{time_approval_waiting_alert}日"
  end

  def display_registration_review_approval_waiting_alert
    "#{registration_review_approval_waiting_alert}日"
  end

  def display_notice_payment_due
    if format_payment_due_date == "end_of_month"
      "#{payment_due_month_i18n}末"
    else
      "#{payment_due_month_i18n}の#{format_payment_due_date}日"
    end
  end
end
