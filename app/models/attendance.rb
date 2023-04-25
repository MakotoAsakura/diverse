# frozen_string_literal: true

class Attendance < ApplicationRecord
  include Base::Document
  include Base::Scope::Base
  include DateTimeAttributeTypeCastConcern

  belongs_to :job
  belongs_to :medical_institution
  belongs_to :candidate

  date_time_attribute :checkin, :checkout, :shift_1_checkin, :shift_1_checkout, :shift_2_checkin, :shift_2_checkout

  enum status: { review: 0, waiting: 1, approved: 2, rejected: 3 }

  # month format: Y-m
  scope :in_month, lambda { |month|
    month = Date.parse("#{month}-1") if month.is_a?(String)
    where(checkin: month.in_time_zone.all_month)
  }

  scope :sent_request, -> { where(status: %i[waiting approved rejected]) }

  scope :in_day, lambda { |date|
    where(checkin: date.in_time_zone.all_day)
  }
  scope :not_calculated_yet, -> { where(calculate_at: nil) }

  scope :by_candidate_job, lambda { |current_medical_id, candidate_id, job_id|
    where(medical_institution_id: current_medical_id, candidate_id: candidate_id, job_id: job_id)
  }

  validates :transportation_fee, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validate :attendance_time_validate
  validate :checkin_time_in_contract_validate

  before_validation :set_break_hours!, :set_work_hours1!

  def set_work_hours1!
    self.work_hours = if checkin_date_before_type_cast == "" || checkin_time_before_type_cast == "" ||
                         checkout_date_before_type_cast == "" || checkout_time_before_type_cast == "" ||
                         checkin.blank? || checkout.blank?
                        0
                      else
                        result = (checkout - checkin) / 3600.0
                        result == result.to_i ? result.to_i : result
                        result - set_break_hours!
                      end
  end

  def set_break_hours!
    self.break_hours =
      begin
        result = 0
        if shift_1_checkin_date_before_type_cast != "" && shift_1_checkin_time_before_type_cast != "" &&
           shift_1_checkout_date_before_type_cast != "" && shift_1_checkout_time_before_type_cast != "" &&
           shift_1_checkin.present? && shift_1_checkout.present?
          result += shift_1_checkout - shift_1_checkin
        end

        if shift_2_checkin_date_before_type_cast != "" && shift_2_checkin_time_before_type_cast != "" &&
           shift_2_checkout_date_before_type_cast != "" && shift_2_checkout_time_before_type_cast != "" &&
           shift_2_checkin.present? && shift_2_checkout.present?
          result += shift_2_checkout - shift_2_checkin
        end

        result /= 3600.0

        result == result.to_i ? result.to_i : result
      end
  end

  def candidate_job
    CandidateJob.find_by(job_id: job_id, candidate_id: candidate_id)
  end

  private

  def attendance_time_validate
    # checkin
    if checkin.blank?
      errors.add(:checkin, :blank)
    else
      errors.add(:checkin_date) if checkin_date_before_type_cast == ""
      errors.add(:checkin_time) if checkin_time_before_type_cast == ""
    end

    # checkout
    if checkout.blank?
      errors.add(:checkout, :blank)
    else
      errors.add(:checkout_date) if checkout_date_before_type_cast == ""
      errors.add(:checkout_time) if checkout_time_before_type_cast == ""
    end

    # shift_1_checkin
    if shift_1_checkout.present? && shift_1_checkin.blank?
      errors.add(:shift_1_checkin, :blank)
    else
      errors.add(:shift_1_checkin_date) if shift_1_checkin_date_before_type_cast == "" && shift_1_checkin_time_before_type_cast != ""
      errors.add(:shift_1_checkin_time) if shift_1_checkin_date_before_type_cast != "" && shift_1_checkin_time_before_type_cast == ""
    end

    # shift_1_checkout
    if shift_1_checkin.present? && shift_1_checkout.blank?
      errors.add(:shift_1_checkout, :blank)
    else
      errors.add(:shift_1_checkout_date) if shift_1_checkout_date_before_type_cast == "" && shift_1_checkout_time_before_type_cast != ""
      errors.add(:shift_1_checkout_time) if shift_1_checkout_date_before_type_cast != "" && shift_1_checkout_time_before_type_cast == ""
    end

    # shift_2_checkin
    if shift_2_checkout.present? && shift_2_checkin.blank?
      errors.add(:shift_2_checkin, :blank)
    else
      errors.add(:shift_2_checkin_date) if shift_2_checkin_date_before_type_cast == "" && shift_2_checkin_time_before_type_cast != ""
      errors.add(:shift_2_checkin_time) if shift_2_checkin_date_before_type_cast != "" && shift_2_checkin_time_before_type_cast == ""
    end

    # shift_2_checkout
    if shift_2_checkin.present? && shift_2_checkout.blank?
      errors.add(:shift_2_checkout, :blank)
    else
      errors.add(:shift_2_checkout_date) if shift_2_checkout_date_before_type_cast == "" && shift_2_checkout_time_before_type_cast != ""
      errors.add(:shift_2_checkout_time) if shift_2_checkout_date_before_type_cast != "" && shift_2_checkout_time_before_type_cast == ""
    end

    return if checkin.blank?

    min = { attribute: :checkin, value: checkin }

    %i[shift_1_checkin shift_1_checkout shift_2_checkin shift_2_checkout checkout].each do |attribute|
      value = public_send(attribute)
      next if value.blank?

      if value < min[:value]
        errors.add(attribute, "#{t(attribute)}は、#{t(min[:attribute])}を含む以降の日時を入力してください。")
      else
        min = { attribute: attribute, value: value }
      end
    end
  end

  def checkin_time_in_contract_validate
    errors.add(:checkin, :invalid) if checkin < candidate_job.contract_start_at.beginning_of_day || checkin > candidate_job.contract_end_at.end_of_day
  end
end
