# frozen_string_literal: true

class PharmaceuticalCompany < ApplicationRecord
  include Base::PermitParams
  include Base::Scope::Base
  include Base::Document

  NUMBER_HALF_WIDTH_REGEXP = /^[0-9]+$/

  attr_writer :zipcode_first, :zipcode_last

  belongs_to :medical_institution, class_name: "MedicalInstitution"

  validates :name, presence: true, length: { maximum: 50 }
  validates :zipcode, length: { maximum: 7 }
  validates :location, length: { maximum: 255 }
  validates :staff_ms, presence: true, length: { maximum: 50 }
  validates :phone_number, length: { maximum: 11, too_long: :phone_valid }
  validates :email, length: { maximum: 255 }
  validate :check_phone, :check_zipcode_first, :check_zipcode_last, :check_incorrect_zipcode, :check_email

  scope :created_at_desc, -> { order(created_at: :desc) }

  class << self
    def search(params)
      search_name(params)
    end

    def search_name(params)
      return all if params.blank? || params[:name].blank?

      all.keyword_in params[:name], :name
    end
  end

  def zipcode_first
    @zipcode_first || (zipcode[0..2] if zipcode)
  end

  def zipcode_last
    @zipcode_last || (zipcode[3..] if zipcode)
  end

  private

  def check_phone
    return if phone_number.blank?

    errors.add(:phone_number, message: :phone_valid) unless phone_number.length >= 10 && phone_number.match?(NUMBER_HALF_WIDTH_REGEXP)
  end

  def check_zipcode_first
    return if phone_number.blank?

    errors.add(:zipcode_first, message: :zipcode_valid) unless zipcode_first.length == 3 && zipcode_first.match?(NUMBER_HALF_WIDTH_REGEXP)
  end

  def check_zipcode_last
    return if zipcode_last.blank?

    errors.add(:zipcode_last, message: :zipcode_valid) unless zipcode_last.length == 4 && zipcode_last.match?(NUMBER_HALF_WIDTH_REGEXP)
  end

  def check_incorrect_zipcode
    return unless zipcode.present? && zipcode.length == 7 && zipcode.match?(NUMBER_HALF_WIDTH_REGEXP)

    postcodes = Jpostcode.find(zipcode)

    return if postcodes.present?

    errors.add(:zipcode_first, message: :zipcode_incorrect)
    errors.add(:zipcode_last, message: :zipcode_incorrect)
  end

  def check_email
    errors.add(:email, message: :email_valid) if email.present? && !email.match?(Devise.email_regexp)
  end
end
