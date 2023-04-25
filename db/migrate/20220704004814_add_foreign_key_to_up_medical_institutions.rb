class AddForeignKeyToUpMedicalInstitutions < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :medical_institutions, :users, column: :user_id
  end
end
