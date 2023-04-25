# frozen_string_literal: true

class Attachment < ApplicationRecord
  belongs_to :owner, polymorphic: true, inverse_of: :owner, optional: true
  has_one_attached :file
  belongs_to :created_by, class_name: "User", optional: true

  validate :limit_size

  scope :created_by_role, ->(role) { joins(:created_by).where(created_by: { role: role }) }

  with_options on: :only_document do
    validate :document_validate
  end

  with_options on: :document_and_image do
    validate :only_document_and_image
  end

  with_options if: :candidate_owner? do
    validate :only_document_and_image
  end

  def filename
    file.blob.filename
  end

  def candidate_owner?
    owner_type == "Candidate"
  end

  private

  def limit_size
    errors.add(:file, :invalid_size) if file.present? && file.blob.byte_size > 10.megabytes
  end

  def document_validate
    return if file.blob.nil? || (file.blob.present? && %w[doc docx xls xlsx pdf].include?(file.blob.filename.extension))

    errors.add(:file, :invalid)
  end

  def only_document_and_image
    return if file.blob.nil? || (file.blob.present? && %w[doc docx xls xlsx pdf svg png jpg jpeg].include?(file.blob.filename.extension))

    errors.add(:file, :invalid)
  end
end
