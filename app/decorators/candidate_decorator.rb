# frozen_string_literal: true

module CandidateDecorator
  OTHER_CERTIFICATE_TYPE = 9

  def full_name
    "#{first_name}　#{last_name}"
  end

  def full_name_kana
    "#{first_name_kana}　#{last_name_kana}"
  end

  def full_address
    "#{prefecture}#{city}#{address}"
  end

  def certificate_text(key)
    value = Candidate.certificates.key(key)

    text = I18n.t("candidate.registration.profile.certificates.#{value}")
    if key == OTHER_CERTIFICATE_TYPE
      "#{text} (#{other_certificates})"
    else
      text
    end
  end

  def final_education_text
    "#{specialization}  #{graduation_year}年卒"
  end

  def age_information_type
    return unless dob

    year_dob = dob.year

    if dob >= Date.new(2019, 0o5, 0o1)
      ["令和", dob.year - 2019 + 1]
    elsif year_dob >= 1912 && year_dob < 1926
      ["大正", year_dob - 1912 + 1]
    elsif year_dob >= 1926 && year_dob < 1989
      ["昭和", year_dob - 1926 + 1]
    elsif year_dob >= 1989 && year_dob <= 2019
      ["平成", year_dob - 1989 + 1]
    else
      ["", ""]
    end
  rescue StandardError
    ["", ""]
  end
end
