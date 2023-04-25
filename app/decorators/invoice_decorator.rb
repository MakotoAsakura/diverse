# frozen_string_literal: true

module InvoiceDecorator
  def display_system_fee
    return "-" unless system_fee

    "#{system_fee}%"
  end

  def display_settlement_date
    return "-" unless settlement_date

    settlement_date.strftime("%Y/%m/%d")
  end

  def display_payment_due_date
    return "-" unless payment_due_date

    payment_due_date.strftime("%Y/%m/%d")
  end

  def display_subtotal_without_prefix
    return "-" unless subtotal

    number_with_delimiter(convert_number_decimal(subtotal)).to_s
  end

  def display_tax_without_prefix
    return "-" unless tax

    "#{number_with_delimiter(convert_number_decimal(tax))}%"
  end

  def display_tax_money_without_prefix
    return "-" unless tax_money

    number_with_delimiter(convert_number_decimal(tax_money)).to_s
  end

  def display_total(payslips, percent_fee)
    return "-" unless payslips

    total = payslips.sum { |p| p.total - p.personal_income_tax + ((p.total - p.total_transportation_fee) * percent_fee * 1.1).round }

    return "-" unless total

    "¥#{number_with_delimiter(convert_number_decimal(total))}"
  end

  def display_total_without_prefix
    return "-" unless total

    number_with_delimiter(convert_number_decimal(total)).to_s
  end
end
