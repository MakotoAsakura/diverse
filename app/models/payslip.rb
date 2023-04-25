# frozen_string_literal: true

class Payslip < ApplicationRecord
  include Base::Scope::Base

  belongs_to :candidate
  belongs_to :medical_institution
  belongs_to :job

  with_options presence: true do
    validates :year, :month, :unit_price, :total_hour, :total_day,
              :total_transportation_fee, :candidate_id, :medical_institution_id
  end

  enum salary_according_to: { day: 0, hour: 1 }

  scope :by_year, ->(year) { where(year: year) }
  scope :by_month, ->(month) { where(month: month) }
  scope :by_full_year, lambda { |year, medical_institution_id, job_id, candidate_id|
    where(medical_institution_id: medical_institution_id, job_id: job_id, candidate_id: candidate_id)
      .where("DATE(CONCAT(year, '-', month, '-', '01')) >= ? and DATE(CONCAT(year, '-', month, '-', '01')) < ?", Time.zone.local(year - 1, 11), Time.zone.local(year).end_of_year)
  }

  def checked_view
    return if viewed_date?

    assign_attributes(viewed_date: Time.zone.now)
    save
  end
end
