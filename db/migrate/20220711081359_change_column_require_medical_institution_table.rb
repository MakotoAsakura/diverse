class ChangeColumnRequireMedicalInstitutionTable < ActiveRecord::Migration[7.0]
  def change
    change_column_null :medical_institutions, :name_kana, false
    change_column_null :medical_institutions, :zipcode, false
    change_column_null :medical_institutions, :location, false
    change_column_null :medical_institutions, :phone_number, false
    change_column_null :medical_institutions, :url, false
    change_column_null :medical_institutions, :first_name_manager, false
    change_column_null :medical_institutions, :last_name_manager, false
    change_column_null :medical_institutions, :first_name_kana_manager, false
    change_column_null :medical_institutions, :last_name_kana_manager, false
  end
end
