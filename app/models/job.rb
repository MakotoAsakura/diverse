# frozen_string_literal: true

class Job < ApplicationRecord
  include Base::PermitParams
  include Base::Scope::Base
  include Base::Document

  serialize :wdays, Array

  attr_accessor :skip_validate_presence

  belongs_to :medical_institution
  has_many :candidate_jobs, dependent: :destroy
  has_many :attendances, dependent: :destroy

  permit_params :title, :position, :address,
                :min_annual_salary, :max_annual_salary, :quantity, :open_at, :close_at,
                :start_at, :end_at, :wday_start_at, :wday_end_at,
                :work_detail, :appealing, :require_skill, :contact, :salary_according_to,
                :including_transportation_allowance, :work_policy, wdays: []

  validates :title, length: { maximum: 100 }
  validates :address, length: { maximum: 255 }
  validates :min_annual_salary, numericality: { greater_than_or_equal_to: 100, less_than_or_equal_to: 999_999, only_integer: true }, allow_nil: true
  validates :max_annual_salary, numericality: { less_than_or_equal_to: 999_999, only_integer: true }, allow_nil: true
  validates :quantity, numericality: { less_than_or_equal_to: 99_999, only_integer: true }
  validates :wdays, length: { maximum: 255 }
  validates :work_detail, length: { maximum: 255 }
  validates :appealing, length: { maximum: 255 }
  validates :require_skill, length: { maximum: 255 }
  validates :contact, length: { maximum: 255 }
  validates :work_policy, length: { maximum: 255 }
  validate :around_start_validate, :around_annual_salary_validate, :around_open_validate

  with_options unless: :skip_validate_presence do
    with_options presence: true do
      validates :title, :address, :position, :max_annual_salary, :min_annual_salary, :quantity, :open_at, :close_at,
                :start_at, :end_at, :wday_start_at, :wday_end_at, :wdays
    end

    with_options presence: { message: :fill_field } do
      validates :work_detail, :appealing, :require_skill, :contact, :work_policy
    end
  end

  before_validation lambda {
    self.open_at = open_at.beginning_of_day if open_at.present?
    self.close_at = close_at.end_of_day if close_at.present?
    self.start_at = start_at.beginning_of_day if start_at.present?
    self.end_at = end_at.end_of_day if end_at.present?
  }

  enum status: { published: 1, ended: 2, draft: 0, unpublished: 3 }
  enum including_transportation_allowance: { included: 0, excluded: 1 }
  enum salary_according_to: { day: 0, hour: 1 }
  enum position: { doctor: 0, dentist: 1, pharmacist: 2, nurse: 3,
                   dental_hygienist: 4, physiotherapist: 5, occupational_therapist: 6,
                   registered_dietitian: 7, caregiver: 8, medical_office: 9, childminder: 10,others: 11 }, _default: :doctor

  scope :opening, lambda {
    current_time = Time.current
    joins(:medical_institution)
      .joins(medical_institution: :user)
      .published.where(medical_institution: { status: :approved })
      .time_compare(:open_at, :lteq, current_time.beginning_of_day)
      .time_compare(:close_at, :gteq, current_time.end_of_day)
  }

  ransacker :start_at, formatter: proc { |v| Time.zone.parse(v).end_of_day }
  ransacker :end_at, formatter: proc { |v| Time.zone.parse(v).beginning_of_day }

  class << self
    def search_for_medical(params)
      search_status(params).search_position(params)
    end

    def search_status(params)
      return all if params.blank? || params[:status].blank?

      value_in params[:status], :status
    end

    def search_position(params)
      return all if params.blank? || params[:position].blank?

      value_in params[:position], :position
    end

    def quantity_options
      (1..100).map { |k| ["#{k}名", k] }
    end

    def wdays_options
      { "月" => 1, "火" => 2, "水" => 3, "木" => 4, "金" => 5, "土" => 6, "日" => 0 }
    end

    def statuses_options
      %w[published ended draft].index_with { |k| statuses_i18n[k] }
    end
  end

  def candidate_applied?
    candidate_jobs.where(status: :review)
                  .or(candidate_jobs.where(status: :waiting))
                  .or(candidate_jobs.where(status: :recruitment)).present?
  end

  def full?
    candidate_jobs.recruitment.count >= quantity
  end

  private

  def around_start_validate
    return if start_at.blank? || end_at.blank?

    errors.add(:end_at, message: :time_invalid) if start_at > end_at
  end

  def around_annual_salary_validate
    return if min_annual_salary.blank? || max_annual_salary.blank?

    errors.add(:max_annual_salary, message: :salary_invalid) if min_annual_salary > max_annual_salary
  end

  def around_open_validate
    return if open_at.blank? || close_at.blank?

    errors.add(:close_at, message: :time_invalid) if open_at > close_at
  end
end
