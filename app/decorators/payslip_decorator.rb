# frozen_string_literal: true

module PayslipDecorator
  def display_total
    return "-" unless total

    "¥#{number_with_delimiter(convert_number_decimal(total - personal_income_tax))}"
  end

  def display_total_without_prefix
    return "-" unless total

    "#{number_with_delimiter(convert_number_decimal(total - personal_income_tax))}円"
  end

  def display_total_without_personal_income_tax
    return "-" unless total

    "#{number_with_delimiter(convert_number_decimal(total))}円"
  end

  def display_total_without_transportation_fee
    return "-" unless total || total_transportation_fee

    "#{number_with_delimiter(convert_number_decimal(total - total_transportation_fee))}円"
  end

  def display_total_system_fee(percent_fee)
    return "-" unless total

    "#{number_with_delimiter(convert_number_decimal((total - total_transportation_fee) * percent_fee))}円"
  end

  def display_total_tax_fee(percent_fee)
    return "-" unless total

    "#{number_with_delimiter(convert_number_decimal((total - total_transportation_fee) * percent_fee * 0.1).round)}円"
  end

  def display_total_tax_system_fee(percent_fee)
    return "-" unless total

    "#{number_with_delimiter(convert_number_decimal((total - total_transportation_fee) * percent_fee * 1.1).round)}円"
  end

  def display_total_income(percent_fee)
    return "-" unless total

    "#{number_with_delimiter(convert_number_decimal(total - personal_income_tax + ((total - total_transportation_fee) * percent_fee * 1.1).round))}円"
  end

  def display_total_day
    return "-" unless total_day

    "#{number_with_delimiter(convert_number_decimal(total_day))}日"
  end

  def display_total_hour
    return "-" unless total_hour

    "#{number_with_delimiter(convert_number_decimal(total_hour))}時間"
  end

  def display_unit_price
    return "-" unless unit_price

    "#{number_with_delimiter(convert_number_decimal(unit_price))}円"
  end

  def display_total_transportation_fee
    return "-" unless total_transportation_fee

    "#{number_with_delimiter(convert_number_decimal(total_transportation_fee))}円"
  end

  def display_personal_income_tax
    return "-" unless personal_income_tax

    "#{number_with_delimiter(convert_number_decimal(personal_income_tax))}円"
  end

  def display_tax_withholding
    return "-" unless tax_withholding

    "#{number_with_delimiter(convert_number_decimal(tax_withholding))}円"
  end
end
