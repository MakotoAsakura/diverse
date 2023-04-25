# frozen_string_literal: true

module MedicalInstitutionDecorator
  def full_name_manager
    "#{first_name_manager}　#{last_name_manager}"
  end

  def full_name_kana_manager
    "#{first_name_kana_manager}　#{last_name_kana_manager}"
  end
end
