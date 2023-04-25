# frozen_string_literal: true

class User < ApplicationRecord
  include Base::PermitParams
  include Base::Scope::Base
  include Base::Document
  include Discard::Model

  default_scope -> { kept }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :timeoutable, authentication_keys: { email: true, role: true }

  attr_accessor :email_confirmation

  has_one :manage, dependent: :destroy, inverse_of: :user
  has_one :candidate, dependent: :destroy, inverse_of: :user
  has_one :medical_institution, dependent: :destroy
  has_many :candidate_jobs, foreign_key: :candidate_id, inverse_of: :candidate, dependent: :destroy
  has_many :jobs, through: :candidate
  has_many :attachments, foreign_key: :created_by_id, dependent: :destroy, inverse_of: :user

  enum role: { admin: 0, medical: 1, user: 2 }

  accepts_nested_attributes_for :manage, update_only: true, allow_destroy: true
  accepts_nested_attributes_for :candidate, update_only: true, allow_destroy: true
  accepts_nested_attributes_for :medical_institution, update_only: true, allow_destroy: true

  permit_params :email, :role, :password, :password_confirmation, :email_confirmation, :reason_delete,
                candidate_attributes: %i[national gender experiences diplomas zipcode dob
                                         first_name last_name first_name_kana last_name_kana year_of_birth
                                         month_of_birth day_of_birth prefecture city address phone_number],
                manage_attributes: %i[first_name last_name]

  delegate :first_name, :last_name, :first_name_kana, :last_name_kana, :gender, :national,
           :dob, :address, :experiences, :diplomas, to: :candidate, prefix: false, allow_nil: true

  validates :email, presence: true, length: { maximum: 100 }, uniqueness: { allow_blank: true, case_sensitive: false },
                    format: { with: Devise.email_regexp, allow_blank: true }
  # validates :password, presence: { if: :password_required? }, confirmation: { if: :password_required? },
  #                      format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\W)[^ ]{8,}\z/, message: :password_format, if: :encrypted_password_changed? }

  before_validation :check_email_confirmation

  def full_name
    case role
    when "admin"
      manage.full_name
    when "user"
      candidate.full_name
    when "medical"
      medical_institution.full_name_manager
    else # rubocop:disable Style/EmptyElse
      nil
    end
  end

  class << self
    def generate_password
      [
        [*"a".."z"].sample(4),
        [*"A".."Z"].sample(3),
        ["#", "?", "!", "@", "$", "%", "^", "&", "*", "-"].sample(1)
      ].sum([]).shuffle.join
    end
  end

  private

  def check_email_confirmation
    return if email_confirmation.nil?

    errors.add(:email_confirmation, :email_confirmation_invalid) if candidate && !email.eql?(email_confirmation)
  end

  def password_required?
    !persisted? || password.present? || password_confirmation.present?
  end
end
