# frozen_string_literal: true

class Notification < ApplicationRecord
  include Base::PermitParams
  include Base::Document
  include Base::Scope::Base

  attribute :status, :integer

  belongs_to :creator, class_name: "User"
  has_many :attachments, as: :owner, dependent: :destroy
  has_many :notification_users, dependent: :destroy
  has_many :users, through: :notification_users
  has_rich_text :content

  enum status: { opening: 1, expired: 2, waiting: 3 }

  scope :opening, lambda {
    current_time = Time.current
    time_compare(:start_time, :lteq, current_time.beginning_of_day)
      .time_compare(:end_time, :gteq, current_time.end_of_day)
  }

  scope :expired, lambda {
    current_time = Time.current
    time_compare(:end_time, :lt, current_time.end_of_day)
  }

  scope :waiting, lambda {
    current_time = Time.current
    time_compare(:start_time, :gt, current_time.beginning_of_day)
  }

  scope :created_at_desc, -> { order(created_at: :desc) }

  validates :title, presence: true
  validates :title, length: { maximum: 50 }
  validates :content, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :time_validate, :attachments_validate

  before_validation lambda {
    self.start_time = start_time.beginning_of_day if start_time.present?
    self.end_time = end_time.end_of_day if end_time.present?
  }

  permit_params :title, :status, :start_time, :end_time, :creator_id, :content

  ransacker :status, formatter: ->(v) { v.to_i } do |_parent|
    current_time = Time.current
    notifications = Notification.arel_table
    Arel::Nodes::Case.new
                     .when(notifications[:start_time].gt(current_time.end_of_day)).then(3)
                     .when(notifications[:end_time].lt(current_time.beginning_of_day)).then(2)
                     .when(notifications[:start_time].lteq(current_time)
                     .and(notifications[:end_time]).gteq(current_time)).then(1)
  end

  ransacker :start_time, formatter: proc { |v| Time.zone.parse(v).beginning_of_day }
  ransacker :end_time, formatter: proc { |v| Time.zone.parse(v).end_of_day }

  def status
    super if start_time.blank? || end_time.blank?

    current_time = Time.current

    return "waiting" if start_time > current_time.end_of_day
    return "expired" if end_time < current_time.beginning_of_day
    return "opening" if start_time <= current_time && current_time <= end_time

    nil
  end

  def read_by_user(user)
    notification_user = notification_users.find_by(user: user)
    return if notification_user

    notification_user = notification_users.new(user: user)
    notification_user.read_at = Time.current
    notification_user.save
  end

  private

  def time_validate
    return unless start_time && end_time && start_time.to_date > end_time.to_date

    errors.add(:time, "#{t(:end_time)}は、#{t(:start_time)}を含む以降の日時を入力してください。")
    errors.add(:start_time, "") # add error style to start_time field
    errors.add(:end_time, "") # add error style to end_time field
  end

  def attachments_validate
    attachments.each do |attachment|
      errors.add(:attachments) unless attachment.validate(:document_and_image)
    end
  end
end
