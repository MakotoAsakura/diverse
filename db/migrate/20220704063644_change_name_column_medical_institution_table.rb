class ChangeNameColumnMedicalInstitutionTable < ActiveRecord::Migration[7.0]
  def change
    rename_column :medical_institutions, :first_name_manger, :first_name_manager
    rename_column :medical_institutions, :first_name_kana_manger, :first_name_kana_manager
  end
end
