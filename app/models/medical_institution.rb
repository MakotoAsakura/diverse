# frozen_string_literal: true

class MedicalInstitution < ApplicationRecord
  include Base::PermitParams
  include Base::Scope::Base
  include Base::Document
  include Base::RegexConstant

  attr_writer :zipcode_first, :zipcode_last

  has_many :jobs, dependent: :destroy
  has_many :payslips, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_one :pharmaceutical_company, dependent: :destroy
  belongs_to :user, class_name: "User"
  belongs_to :creator, class_name: "User", optional: true

  accepts_nested_attributes_for :user, :pharmaceutical_company, update_only: true, allow_destroy: true

  permit_params :name, :name_kana, :url, :zipcode_first, :zipcode_last, :location, :phone_number,
                :first_name_manager, :last_name_manager, :first_name_kana_manager, :last_name_kana_manager,
                user_attributes: %i[email email_confirmation password password_confirmation],
                pharmaceutical_company_attributes: %i[name staff_ms]

  before_validation :set_zipcode

  validates :name, presence: true, length: { maximum: 50 }
  validates :name_kana, presence: true, length: { maximum: 50 }
  validates :zipcode, presence: true, length: { maximum: 7 }
  validates :location, presence: true, length: { maximum: 255 }
  validates :phone_number, presence: { message: :phone_valid }
  validates :url, presence: { message: :url_invalid }, length: { maximum: 255 }
  validates :first_name_manager, presence: true, length: { maximum: 50 }
  validates :last_name_manager, presence: true, length: { maximum: 50 }
  validates :first_name_kana_manager, presence: true, length: { maximum: 255 }
  validates :last_name_kana_manager, presence: true, length: { maximum: 255 }

  validate :check_phone, :check_zipcode_first, :check_zipcode_last, :check_incorrect_zipcode, :name_kana_validate,
           :check_url

  enum status: { pending: 0, approved: 1, rejected: 2 }

  delegate :name, :phone_number, :zipcode, :staff_ms, :email, :location, to: :pharmaceutical_company, prefix: true, allow_nil: true
  delegate :email, to: :user, prefix: true, allow_nil: true

  scope :created_at_desc, -> { order(created_at: :desc) }
  scope :medical_institution_working, lambda { |current_user_id|
    joins(jobs: :candidate_jobs).where(candidate_jobs: { candidate: current_user_id, status: "recruitment" })
  }
  scope :self_registration, -> { where(creator_id: nil) }

  class << self
    def search(params)
      search_name(params).search_location(params)
    end

    def search_medical_institution_applying(params)
      search_name(params).search_status(params).search_location(params)
    end

    def search_name(params)
      return all if params.blank? || params[:name].blank?

      all.keyword_in params[:name], :name
    end

    def search_location(params)
      return all if params.blank? || params[:location].blank?

      all.keyword_in params[:location], :location
    end

    def search_status(params)
      return all if params.blank? || params[:status].blank? || params[:status].include?("all")

      all.value_in params[:status], :status
    end

    def statuses_options
      %w[all pending approved rejected].index_with { |k| I18n.t("enums.medical_institution.status.#{k}") }
    end
  end

  def attendances_waiting
    attendances.where(status: :waiting)
  end

  def zipcode_first
    @zipcode_first || (zipcode[0..2] if zipcode)
  end

  def zipcode_last
    @zipcode_last || (zipcode[3..] if zipcode)
  end

  def full_name_manager
    "#{first_name_manager}　#{last_name_manager}"
  end

  delegate :discarded?, to: :user, prefix: true

  private

  def set_zipcode
    self.zipcode = "#{zipcode_first}#{zipcode_last}"
  end

  def check_phone
    return if phone_number.blank?

    phone_number_normalize = phone_number.delete("-")
    errors.add(:phone_number, message: :phone_valid) unless phone_number_normalize.length <= 11 && phone_number_normalize.length >= 10 && phone_number_normalize.match?(NUMBER_HALF_WIDTH_REGEXP)
  end

  def check_zipcode_first
    errors.add(:zipcode_first, message: :zipcode_valid) unless zipcode_first.present? && zipcode_first.length == 3 && zipcode_first.match?(NUMBER_HALF_WIDTH_REGEXP)
  end

  def check_zipcode_last
    errors.add(:zipcode_last, message: :zipcode_valid) unless zipcode_last.present? && zipcode_last.length == 4 && zipcode_last.match?(NUMBER_HALF_WIDTH_REGEXP)
  end

  def check_incorrect_zipcode
    return unless zipcode.present? && zipcode.length == 7 && zipcode.match?(NUMBER_HALF_WIDTH_REGEXP)

    postcodes = Jpostcode.find(zipcode)

    return if postcodes.present?

    errors.add(:zipcode_first, message: :zipcode_incorrect)
    errors.add(:zipcode_last, message: :zipcode_incorrect)
  end

  def check_name_kana(name_kana, field)
    errors.add(field, message: :name_kana_valid) unless name_kana.present? && name_kana.match?(KANA_REGEXP)
  end

  def name_kana_validate
    check_name_kana(name_kana, :name_kana) if name_kana.present?
    check_name_kana(first_name_kana_manager, :first_name_kana_manager) if first_name_kana_manager.present?
    check_name_kana(last_name_kana_manager, :last_name_kana_manager) if last_name_kana_manager.present?
  end

  def check_url
    return if url.blank? || (url.present? && url.match?(URL_REGEXP))

    errors.add(:url, :url_invalid)
  end
end
