# frozen_string_literal: true

class Candidate < ApplicationRecord
  include Base::PermitParams
  include Base::Scope::Base
  include Base::Document
  include Base::RegexConstant
  include CandidateDecorator

  attr_writer :zipcode_first, :zipcode_last, :year_of_birth, :month_of_birth, :day_of_birth

  serialize :certificates, Array

  belongs_to :user, -> { unscope(where: User.discard_column) }, inverse_of: :candidate

  has_one :bank, dependent: :destroy
  has_many :candidate_jobs, dependent: :destroy
  has_many :candidate_job_workings, -> { where("candidate_jobs.status" => "recruitment") },
           class_name: "CandidateJob", dependent: :destroy, inverse_of: :candidate
  has_many :jobs, through: :candidate_jobs
  has_many :job_workings, through: :candidate_job_workings, source: :job, class_name: "Job"
  has_many :profiles, class_name: "Profile", inverse_of: :candidate, dependent: :destroy
  has_many :attachments, as: :owner, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :medical_institutions, -> { distinct }, through: :job_workings
  has_many :payslips, dependent: :destroy

  enum gender: { male: 0, female: 1 }

  enum national: { japan: 0, non_japan: 1 }

  enum certificate: {
    doctor: 0,
    dental: 1,
    pharmacist: 2,
    nurse: 10,
    dental_hygienist: 3,
    physical_therapist: 4,
    occupational_therapist: 5,
    care_worker: 6,
    medical_office: 7,
    registered_dietitian: 8,
	childminder: 9,
    others: 10
  }

  delegate :email, to: :user, prefix: true, allow_nil: true

  accepts_nested_attributes_for :user, update_only: true, allow_destroy: true
  accepts_nested_attributes_for :profiles, allow_destroy: true, reject_if: :reject_profile
  accepts_nested_attributes_for :attachments, update_only: true, allow_destroy: true,
                                              reject_if: proc { |attributes| attributes["description"].blank? && attributes["file"].blank? }

  permit_params :national, :gender, :experiences, :diplomas, :zipcode, :dob,
                :first_name, :last_name, :first_name_kana, :last_name_kana, :year_of_birth,
                :month_of_birth, :day_of_birth, :prefecture, :city, :address, :phone_number,
                user_attributes: %i[email email_confirmation password password_confirmation]

  before_validation :set_certificates
  before_validation :set_dob

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :first_name_kana, presence: true, length: { maximum: 50 }
  validates :last_name_kana, presence: true, length: { maximum: 50 }
  validates :dob, presence: true
  validates :prefecture, presence: true, length: { maximum: 255 }
  validates :city, presence: true, length: { maximum: 255 }
  validates :address, length: { maximum: 255 }
  validates :phone_number, presence: true
  validates :graduation_year, numericality: { only_integer: true }, allow_nil: true
  validates :specialization, length: { maximum: 255 }
  validates :skill, length: { maximum: 255 }

  validate :check_zipcode, :check_incorrect_zipcode, :name_kana_validate, :check_year_of_birth, :check_month_of_birth, :check_day_of_birth,
           :check_dob, :check_phone, :check_certificates

  with_options on: :apply_job do
    validates :certificates, :specialization, :graduation_year, :skill, presence: true
    validate :profiles_present_validate
  end

  # custom ransacker
  ransacker :full_name do |parent|
    Arel::Nodes::NamedFunction.new("CONCAT_WS", [
                                     Arel::Nodes.build_quoted(" "), parent.table[:first_name], parent.table[:last_name]
                                   ])
  end

  ransacker :full_address do |parent|
    Arel::Nodes::NamedFunction.new("CONCAT_WS", [
                                     Arel::Nodes.build_quoted(""), parent.table[:prefecture], parent.table[:city], parent.table[:address]
                                   ])
  end

  def zipcode_first
    @zipcode_first || (zipcode[0..2] if zipcode)
  end

  def zipcode_last
    @zipcode_last || (zipcode[3..] if zipcode)
  end

  def year_of_birth
    @year_of_birth || dob&.year
  end

  def month_of_birth
    @month_of_birth || dob&.month
  end

  def day_of_birth
    @day_of_birth || dob&.day
  end

  class << self
    def search(params)
      search_name(params).search_address(params).search_email(params)
    end

    def search_name(params)
      return all if params.blank? || params[:name].blank?

      where("CONCAT_WS(' ', first_name, last_name) LIKE ?", "%#{params[:name]}%")
    end

    def search_address(params)
      return all if params.blank? || params[:address].blank?

      where("CONCAT_WS('', prefecture, city, candidates.address) LIKE ?", "%#{params[:address]}%")
    end

    def search_email(params)
      return all if params.blank? || params[:email].blank?

      all.joins(:user).where("users.email like ?", "%#{params[:email]}%")
    end
  end

  def assign_attributes(attributes)
    if attributes[:profiles_attributes].present?
      attributes[:profiles_attributes] = attributes[:profiles_attributes].each do |_key, profiles_attributes|
        profiles_attributes[:_destroy] = profiles_attributes[:_destroy] == "1" || profiles_attributes[:_destroy] == true ||
                                         (profiles_attributes[:year_start_work].blank? && profiles_attributes[:month_start_work].blank? &&
                                         profiles_attributes[:note].blank? && profiles_attributes[:year_end_work].blank? &&
                                         profiles_attributes[:year_end_work].blank?)
      end
    end

    super
  end

  delegate :discarded?, to: :user, prefix: true

  private

  def set_certificates
    self.certificates = certificates.map(&:to_i)
  end

  def set_dob
    self.dob = "#{year_of_birth}/#{month_of_birth}/#{day_of_birth}"
  end

  def reject_profile(attributes)
    attributes["year_start_work"].blank? && attributes["month_start_work"].blank? && attributes["note"].blank? &&
      attributes["year_end_work"].blank? && attributes["year_end_work"].blank?
  end

  def check_phone
    return if phone_number.blank?

    phone_number_normalize = phone_number.delete("-")
    errors.add(:phone_number, message: :phone_valid) unless phone_number_normalize.length <= 11 && phone_number_normalize.length >= 10 && phone_number_normalize.match?(NUMBER_HALF_WIDTH_REGEXP)
  end

  def check_dob
    self.dob = dob_before_type_cast.to_date
    raise Date::Error if dob > Time.current || dob < Time.zone.local(1900)
  rescue Date::Error
    errors.add(:year_of_birth, message: "")
    errors.add(:month_of_birth, message: "")
    errors.add(:day_of_birth, message: "")
  end

  def check_year_of_birth
    errors.add(:year_of_birth, message: "") unless year_of_birth.present? || year_of_birth.match?(NUMBER_HALF_WIDTH_REGEXP)
  end

  def check_month_of_birth
    errors.add(:month_of_birth, message: "") unless month_of_birth.present? || month_of_birth.match?(NUMBER_HALF_WIDTH_REGEXP)
  end

  def check_day_of_birth
    errors.add(:day_of_birth, message: "") unless day_of_birth.present? || day_of_birth.match?(NUMBER_HALF_WIDTH_REGEXP)
  end

  def check_zipcode
    errors.add(:zipcode, message: :zipcode_valid) unless zipcode.present? && zipcode.length == 7 && zipcode.match?(NUMBER_HALF_WIDTH_REGEXP)
  end

  def check_incorrect_zipcode
    return unless zipcode.present? && zipcode.length == 7 && zipcode.match?(NUMBER_HALF_WIDTH_REGEXP)

    postcodes = Jpostcode.find(zipcode)

    return if postcodes.present?

    errors.add(:zipcode, message: :zipcode_valid)
    errors.add(:zipcode_first, message: :zipcode_incorrect)
    errors.add(:zipcode_last, message: :zipcode_incorrect)
  end

  def check_name_kana(name_kana, field)
    errors.add(field, message: :name_kana_valid) unless name_kana.present? && name_kana.match?(KANA_REGEXP)
  end

  def name_kana_validate
    check_name_kana(first_name_kana, :first_name_kana) if first_name_kana.present?
    check_name_kana(last_name_kana, :last_name_kana) if last_name_kana.present?
  end

  def check_certificates
    errors.add(:other_certificates, message: :not_blank) if certificates.present? && certificates.include?(9) && other_certificates.blank?
  end

  def profiles_present_validate
    return unless profiles.size.zero?

    errors.add(:profiles, :blank)
    # add error class to view
    profile = Profile.new(year_start_work: "", month_start_work: "", year_end_work: "", month_end_work: "")
    profile.validate
    profiles << profile
  end
end
