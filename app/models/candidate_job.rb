# frozen_string_literal: true

class CandidateJob < ApplicationRecord
  include Base::PermitParams
  include Base::Scope::Base
  include Base::Document

  attr_accessor :employee_waiting_message

  belongs_to :job, inverse_of: :candidate_jobs
  belongs_to :candidate, inverse_of: :candidate_jobs
  has_many :attachments, as: :owner, dependent: :destroy

  accepts_nested_attributes_for :attachments, allow_destroy: true,
                                              reject_if: proc { |attributes| attributes["file"].blank? }

  with_options if: :become_waiting do
    validates :salary_detail, presence: true
    validates :salary_details_according_to, presence: true
    validates :contract_start_at, presence: true
    validates :contract_end_at, presence: true
    validate :contract_around_validate
  end

  with_options if: :become_recruitment do
    validate :job_quantity_validate
  end

  enum status: { review: 0, waiting: 1, recruitment: 2, decline: 3, rejected: 4 }, _default: :review
  enum salary_details_according_to: { d_day: 0, d_hour: 1 }
  enum including_transportation_allowance: { included: 0, excluded: 1 }

  permit_params :salary_detail, :salary_details_according_to, :including_transportation_allowance, :remark,
                :contract_start_at, :contract_end_at

  def view!
    update!(viewed_date: Time.current) if viewed_date.blank?
  end

  def generate_contract_id
    str_time = Time.current.strftime("%Y%m%d")
    count_id = CandidateJob.where("contract_id LIKE ?", "#{str_time}%").count + 1
    self.contract_id = "#{str_time}-#{count_id.to_s.rjust(4, '0')[-4..]}"
  end

  private

  def become_waiting
    status_changed?(from: "review", to: "waiting")
  end

  def become_recruitment
    status_changed?(to: "recruitment")
  end

  def contract_around_validate
    return if contract_start_at.blank? || contract_end_at.blank?

    errors.add(:contract_end_at, message: :time_invalid) if contract_start_at > contract_end_at
  end

  def job_quantity_validate
    errors.add(:base, I18n.t("employee.job_applied.views.show.job_fulled")) if job.full?
  end
end
