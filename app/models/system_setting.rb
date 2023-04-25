# frozen_string_literal: true

class SystemSetting < ApplicationRecord
  include Base::PermitParams
  include Base::Scope::Base
  include Base::Document
  include Base::RegexConstant

  attr_writer :zipcode_first, :zipcode_last

  with_options presence: true do
    validates :transportation_allowance, :settlement_expiration_date, :settlement_date, :settlement_hour,
              :payment_due_month, :payment_due_date, :invoice_name, :address, :zipcode, :zipcode_first, :zipcode_last,
              :phone_number, :bank_name, :branch_name, :account_type, :account_number, :holder_name, :holder_name_kana,
              :system_fee, :pharmaceutical_introduction_fee, :job_acceptance_waiting_alert, :time_approval_waiting_alert,
              :registration_review_approval_waiting_alert, :email_contact
  end
  with_options length: { maximum: 50 } do
    validates :invoice_name, :bank_name, :branch_name, :holder_name, :holder_name_kana
  end
  validates :account_number, length: { maximum: 8 }
  validates :address, length: { maximum: 255 }
  validates :email_contact, format: { with: Devise.email_regexp, allow_blank: true }

  enum payment_due_month: { current_month: 0, next_month: 1, two_month_later: 2 }
  enum account_type: { usually: 0, current: 1 }

  permit_params :settlement_expiration_date, :settlement_date, :settlement_hour, :payment_due_month,
                :payment_due_date, :invoice_name, :address, :zipcode, :zipcode_first, :zipcode_last, :phone_number,
                :bank_name, :branch_name, :account_type, :account_number, :holder_name, :holder_name_kana, :system_fee,
                :pharmaceutical_introduction_fee, :job_acceptance_waiting_alert, :time_approval_waiting_alert,
                :registration_review_approval_waiting_alert, :email_contact

  def format_settlement_expiration_date
    settlement_expiration_date == "end_of_month" ? settlement_expiration_date : settlement_expiration_date.to_i
  end

  def format_settlement_date
    settlement_date == "end_of_month" ? settlement_date : settlement_date.to_i
  end

  def format_payment_due_date
    payment_due_date == "end_of_month" ? payment_due_date : payment_due_date.to_i
  end

  def settlement_expiration_date_value
    settlement_expiration_date == "end_of_month" ? Date.current.end_of_month.day : settlement_expiration_date.to_i
  end

  def settlement_date_value
    format_settlement_date == "end_of_month" ? Date.current.end_of_month.day : settlement_date.to_i
  end

  def payment_due_date_value
    format_payment_due_date == "end_of_month" ? Date.current.end_of_month.day : payment_due_date.to_i
  end

  def current_settlement_expiration_date
    year = Date.current.year
    month = Date.current.month
    day = format_settlement_expiration_date == "end_of_month" ? Date.current.end_of_month.day : format_settlement_expiration_date

    Date.new(year, month, day)
  end

  def current_settlement_date
    year = Date.current.year
    month = Date.current.month
    day = format_settlement_date == "end_of_month" ? Date.current.end_of_month.day : format_settlement_date

    Date.new(year, month, day)
  end

  def current_payment_due_date
    year = Date.current.year
    month = Date.current.month if current_month?
    month = Date.current.next_month.month if next_month?
    month = Date.current.months_since(2).month if two_month_later?
    day = format_payment_due_date == "end_of_month" ? Date.current.end_of_month.day : format_payment_due_date
    Date.new(year, month, day)
  end

  def zipcode_first
    @zipcode_first || (zipcode[0..2] if zipcode)
  end

  def zipcode_last
    @zipcode_last || (zipcode[3..] if zipcode)
  end

  class << self
    def date_options
      options = (1..27).map do |k|
        ["#{k}日", k]
      end

      options.push [I18n.t("system_settings.options.end_of_month"), "end_of_month"]
    end

    def payment_due_month_option
      payment_due_months_i18n.map { |k, v| [v, k] }
    end

    def percent_options
      (0..10).map do |k|
        ["#{k * 10}%", k * 10]
      end
    end

    def alert_date_options
      (0..3).map do |k|
        ["#{k}日", k]
      end
    end
  end

  private

  def check_name_kana(name_kana, field)
    errors.add(field, message: :name_kana_valid) unless name_kana.present? && name_kana.match?(KANA_REGEXP)
  end
end
