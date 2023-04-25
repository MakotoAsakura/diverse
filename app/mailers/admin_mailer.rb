# frozen_string_literal: true

class AdminMailer < ApplicationMailer
  def create_manage(admin, manage, password)
    @manage = manage
    @password = password

    mail to: [admin.email, manage.user_email].uniq
  end

  def update_manage(admin, manage)
    @manage = manage

    mail to: [admin.email, manage.user_email].uniq
  end

  def destroy_manage(admin, full_name, email)
    @full_name = full_name
    @email = email

    mail to: [admin.email, email].uniq
  end

  def create_medical(admin, medical, password)
    @medical = medical
    @password = password

    mail to: admin.email
  end

  def update_medical(admin, medical)
    @medical = medical

    mail to: admin.email
  end

  def destroy_medical(admin, medical = {})
    return unless medical[:user_email]

    @medical = medical

    mail to: admin.email
  end

  def register_medical(emails, medical)
    @medical = medical

    mail to: emails
  end

  def complete_approval(emails, medical)
    @medical = medical

    mail to: emails
  end

  def send_payslip_pdf(year, month, candidate_job, candidate, _pdf_path, manage)
    @year = year
    @month = month
    @candidate_job = candidate_job
    @candidate = candidate

    mail(to: manage&.user_email)
  end

  def send_invoice_pdf(year, month, medical_institution, _pdf_path, manage)
    @year = year
    @month = month
    @medical_institution = medical_institution

    mail(to: manage&.user_email)
  end

  def send_withholding_slip_pdf(year, candidate_job, candidate, _pdf_path, manage)
    @year = year
    @candidate_job = candidate_job
    @candidate = candidate

    mail(to: manage&.user_email)
  end

  def inquiry_complete; end

  def update_password(admin)
    @admin = admin

    mail to: admin.email
  end

  def after_resetting_password(admin)
    @admin = admin

    mail to: admin.email
  end

  private

  def remove_files(files)
    files.each do |file|
      File.delete(file) if File.exist?(file)
    end
  end
end
