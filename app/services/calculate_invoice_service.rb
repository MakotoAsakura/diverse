# frozen_string_literal: true

class CalculateInvoiceService
  def perform
    current_date = Date.current
    # month = current_date.month TODO: uncomment on production
    year = current_date.year # TODO: remove on production
    months = 1..12
    system_setting = SystemSetting.last

    months.each do |month| # TODO: remove on production
      MedicalInstitution.approved.each do |medical_institution|
        payslips = medical_institution.payslips.by_year(year).by_month(month)
        next if payslips.blank?

        # invoice_total = payslips.pick("SUM(total)")
        # invoice_system_fee = invoice_total * system_setting.system_fee.percent_of(100) / 100
        # subtotal = invoice_total + invoice_system_fee
        # tax_money = subtotal * 0.1
        # total = subtotal + tax_money

        invoice = Invoice.new(
          medical_institution: medical_institution,
          tax: 10, # default value 10%
          system_fee: SystemSetting.last.system_fee,
          year: year,
          month: month,
          settlement_date: system_setting.current_settlement_date,
          payment_due_date: system_setting.current_payment_due_date,
          total: 0,
          subtotal: 0,
          tax_money: 0
        )

        invoice.save!
      end
    end
  end
end
