# frozen_string_literal: true

class Contact < ApplicationRecord
  include Base::PermitParams
  include Base::Document

  validates :name, :email, :title, :content, presence: true
  validates :email, length: { maximum: 100 }, format: { with: Devise.email_regexp }

  permit_params :name, :email, :title, :content

  after_create_commit :send_contact_to_admin, :send_contact_to_user

  private

  def send_contact_to_admin
    ContactMailer.send_contact_to_admin(self).deliver_later
  end

  def send_contact_to_user
    ContactMailer.send_contact_confirm(self).deliver_later
  end
end
