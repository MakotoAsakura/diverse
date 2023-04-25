# frozen_string_literal: true

class MedicalInstitutionMailer < ApplicationMailer
  def account_update(medical)
    @medical = medical

    mail to: medical.user_email
  end

  def create_medical(medical, password)
    @medical = medical
    @password = password

    mail to: medical.user_email
  end

  def update_medical(medical)
    @medical = medical

    mail to: medical.user_email
  end

  def destroy_medical(medical = {})
    return unless medical[:user_email]

    @medical = medical

    mail to: medical[:user_email]
  end

  def register_medical(medical)
    @medical = medical

    mail to: medical.user_email
  end

  def complete_approval(medical)
    @medical = medical

    mail to: medical.user_email
  end

  def apply_candidate(candidate_job)
    @candidate_job = candidate_job

    mail(to: candidate_job.job.medical_institution.user_email)
  end

  def reject_candidate(candidate_job)
    @candidate_job = candidate_job

    mail(to: candidate_job.job.medical_institution.user_email)
  end

  def create_apply_job(candidate_job)
    @candidate_job = candidate_job

    mail to: candidate_job.job.medical_institution.user_email
  end

  def apply_job(candidate_job)
    @candidate_job = candidate_job

    mail(to: candidate_job.job.medical_institution.user_email)
  end

  def reject_job(candidate_job)
    @candidate_job = candidate_job

    mail(to: candidate_job.job.medical_institution.user_email)
  end

  def send_invoice_pdf(year, month, medical_institution, _pdf_path)
    @year = year
    @month = month
    @medical_institution = medical_institution

    mail to: medical_institution.user_email
  end

  def contact_updated(candidate_job)
    @candidate_job = candidate_job

    mail to: candidate_job.job.medical_institution.user_email
  end

  def after_resetting_password(medical)
    @medical = medical

    mail to: medical.user_email
  end
end
