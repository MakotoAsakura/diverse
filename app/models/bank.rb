# frozen_string_literal: true

class Bank < ApplicationRecord
  include Base::PermitParams
  include Base::Scope::Base
  include Base::Document

  belongs_to :candidate

  enum account_type: { usually: 0, current: 1 }, _default: "usually"

  after_save :send_mail

  permit_params :bank_name, :branch_name, :account_type, :account_holder_name, :account_number

  validates :bank_name, presence: true, length: { maximum: 255 }
  validates :branch_name, presence: true, length: { maximum: 255 }
  validates :account_type, presence: true
  validates :account_holder_name, presence: true, length: { maximum: 255 }
  validates :account_number, presence: true, length: { maximum: 7, message: I18n.t("employee.bank.errors.account_number.7_digits") }

  private

  def send_mail
    CandidateMailer.change_bank_info(candidate).deliver_later
  end
end
