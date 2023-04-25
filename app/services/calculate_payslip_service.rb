# frozen_string_literal: true

class CalculatePayslipService
  def perform
    current_date = Date.current
    year = current_date.year
    # month = current_date.month # TODO: uncomment on production
    months = 1..12 # TODO: remove on production

    months.each do |month| # TODO: remove on production
      # TODO: uncomment on production
      # settlement_expiration_date = SystemSetting.first.settlement_expiration_date_value
      # settlement_expiration_from = Date.new(current_date.prev_month.year, current_date.prev_month.month, 1).in_time_zone.beginning_of_day
      # settlement_expiration_to = Date.new(year, month, settlement_expiration_date).in_time_zone.end_of_day
      # TODO: uncomment on production

      # TODO: remove on production
      date_temp = Date.new(year, month, 1)
      settlement_expiration_date = SystemSetting.first.settlement_expiration_date == "end_of_month" ? date_temp.end_of_month.day : SystemSetting.first.settlement_expiration_date.to_i
      settlement_expiration_from = Date.new(date_temp.prev_month.year, date_temp.prev_month.month, 1).in_time_zone.beginning_of_day
      settlement_expiration_to = Date.new(year, month, settlement_expiration_date).in_time_zone.end_of_day
      # TODO: remove on production

      candidate_jobs = CandidateJob.recruitment
                                   .time_compare(:contract_start_at, :lteq, settlement_expiration_to)
                                   .time_compare(:contract_end_at, :gteq, settlement_expiration_from)

      candidate_jobs.each do |candidate_job|
        candidate = candidate_job.candidate
        job = candidate_job.job
        medical_institution = job.medical_institution
        unit_price = candidate_job.salary_detail
        salary_according_to = candidate_job.salary_details_according_to_before_type_cast
        attendances = Attendance.approved
                                .not_calculated_yet
                                .time_compare(:checkin, :gteq, settlement_expiration_from)
                                .time_compare(:checkin, :lteq, settlement_expiration_to)
                                .where(medical_institution_id: medical_institution.id)
                                .where(candidate_id: candidate.id)
                                .where(job_id: job.id)

        if attendances.present?
          total_hour, total_transportation_fee = attendances.pick("SUM(work_hours)", "SUM(transportation_fee)")
          total_day = attendances.group_by { |attendance| attendance.checkin.day }.count
          total_transportation_fee = total_transportation_fee.presence || 0
        else
          total_hour = 0
          total_day = 0
          total_transportation_fee = 0
        end

        unit_price = unit_price.to_i
        total_salary = candidate_job.d_day? ? unit_price.to_i * total_day : unit_price * total_hour
        total = total_salary + total_transportation_fee
        personal_income_tax = TaxWithholding.find_tax_by_range(total).to_f.round
        tax_withholding = TaxWithholding.find_tax_by_range(total_salary).to_f.round

        payslip = Payslip.new(candidate: candidate,
                              medical_institution: medical_institution,
                              job: job,
                              year: year,
                              month: month,
                              total: total,
                              unit_price: unit_price,
                              salary_according_to: salary_according_to,
                              total_hour: total_hour,
                              total_day: total_day,
                              total_transportation_fee: total_transportation_fee.presence || 0,
                              personal_income_tax: personal_income_tax,
                              tax_withholding: tax_withholding)
        attendances.update_all(calculate_at: DateTime.current) if payslip.save! && attendances.present? # rubocop:disable Rails/SkipsModelValidations
      end
    end
  end

  def reset_data
    Attendance.update_all(calculate_at: nil) # rubocop:disable Rails/SkipsModelValidations
    CalculatePayslipRunner.destroy_all
    Payslip.destroy_all
    Invoice.destroy_all
  end
end
