class AddReasonToMedicalInstitutionTable < ActiveRecord::Migration[7.0]
  def change
    add_column :medical_institutions, :reason, :text
  end
end
