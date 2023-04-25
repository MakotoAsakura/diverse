# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :candidate
  attribute :year_start_work
  attribute :year_end_work
  attribute :month_start_work
  attribute :month_end_work

  before_validation :set_date
  validate :check_start_date, :check_end_date, :check_date

  validates :note, presence: { message: :not_blank }

  def year_start_work
    attributes["year_start_work"] || date_start_work&.year
  end

  def year_end_work
    attributes["year_end_work"] || date_end_work&.year
  end

  def month_start_work
    attributes["month_start_work"] || date_start_work&.month
  end

  def month_end_work
    attributes["month_end_work"] || date_end_work&.month
  end

  private

  def set_date
    self.date_start_work = "#{year_start_work}/#{month_start_work}"
    self.date_end_work = "#{year_end_work}/#{month_end_work}"
  end

  def check_start_date
    return if year_start_work.nil? && month_start_work.nil?
    raise Date::Error if year_start_work == "" && month_start_work == ""

    self.date_start_work = date_start_work_before_type_cast.to_date
    raise Date::Error if date_start_work < candidate.dob
  rescue Date::Error
    errors.add(:year_start_work, message: "")
    errors.add(:month_start_work, message: "")
  end

  def check_end_date
    return if year_end_work.nil? && month_end_work.nil?
    raise Date::Error if year_end_work == "" && month_end_work == ""

    self.date_end_work = date_end_work_before_type_cast.to_date
    raise Date::Error if date_end_work < candidate.dob
  rescue Date::Error
    errors.add(:year_end_work, message: "")
    errors.add(:month_end_work, message: "")
  end

  def check_date
    return if date_start_work.nil? || date_end_work.nil? || date_start_work <= date_end_work

    errors.add(:year_start_work, message: "")
    errors.add(:month_start_work, message: "")
    errors.add(:year_end_work, message: "")
    errors.add(:month_end_work, message: "")
  end
end
