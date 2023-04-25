# frozen_string_literal: true

class ContactMailer < ApplicationMailer
  def send_contact_to_admin(contact)
    @contact = contact
    mail to: SystemSetting.last.email_contact
  end

  def send_contact_confirm(contact)
    @contact = contact
    mail to: contact.email
  end
end
