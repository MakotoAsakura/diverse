# frozen_string_literal: true

class CandidateMailer < ApplicationMailer
  def account_update(candidate)
    @candidate = candidate

    mail to: candidate.user_email
  end

  def account_destroy(email, full_name)
    @full_name = full_name

    mail to: email
  end

  def register_candidate(candidate)
    @candidate = candidate

    mail to: candidate.user_email
  end

  def apply_candidate(candidate_job)
    @candidate_job = candidate_job

    mail(to: candidate_job.candidate.user_email)
  end

  def reject_candidate(candidate_job)
    @candidate_job = candidate_job

    mail(to: candidate_job.candidate.user_email)
  end

  def create_apply_job(candidate_job, room_chat)
    @candidate_job = candidate_job
    @room_code = room_chat.room_code

    mail to: candidate_job.candidate.user_email
  end

  def apply_job(candidate_job)
    @candidate_job = candidate_job

    mail to: candidate_job.candidate.user_email
  end

  def reject_job(candidate_job)
    @candidate_job = candidate_job

    mail to: candidate_job.candidate.user_email
  end

  def change_bank_info(candidate)
    @candidate = candidate

    mail to: candidate.user_email
  end

  def send_payslip_pdf(year, month, candidate, _pdf_path)
    @candidate = candidate
    @year = year
    @month = month

    mail(to: @candidate&.user_email)
  end

  def send_withholding_slip_pdf(year, candidate, pdf_path)
    @candidate = candidate
    @year = year
    attachments[pdf_path] = File.binread(pdf_path) if File.exist?(pdf_path)

    mail(to: @candidate&.user_email)
  end

  def inquiry_complete; end

  def contact_updated(candidate_job)
    @candidate_job = candidate_job

    mail to: candidate_job.candidate.user_email
  end

  def update_password(candidate)
    @candidate = candidate

    mail to: candidate.email
  end

  def after_resetting_password(candidate)
    @candidate = candidate

    mail to: candidate.email
  end
end
