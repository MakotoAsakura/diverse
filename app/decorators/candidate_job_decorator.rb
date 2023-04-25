# frozen_string_literal: true

module CandidateJobDecorator
  def display_salary(item)
    return "-" if item.salary_detail.blank?

    "#{number_with_delimiter(item.salary_detail)}円（時給）"
  end

  def display_around_contract_start(item)
    return "-" if item.contract_start_at.blank? || item.contract_end_at.blank?

    "#{l(item.contract_start_at, format: :long_day)}　〜　#{l(item.contract_end_at, format: :long_day)}"
  end
end
