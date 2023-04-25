class AddForeignKeyMissing < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :messages, :users, column: :user_id
    add_foreign_key :messages, :rooms, column: :room_id
    add_foreign_key :notifications, :users, column: :user_id
    add_foreign_key :jobs, :medical_institutions, column: :medical_institution_id
    add_foreign_key :pharmaceutical_companies, :medical_institutions, column: :medical_institution_id
    add_foreign_key :candidates, :users, column: :user_id
    add_foreign_key :candidate_jobs, :users, column: :user_id
    add_foreign_key :candidate_jobs, :candidates, column: :candidate_id
    add_foreign_key :attendances, :medical_institutions, column: :medical_institution_id
    add_foreign_key :attendances, :candidates, column: :candidate_id
    add_foreign_key :application_documents, :candidates, column: :candidate_id
    add_foreign_key :banks, :candidates, column: :candidate_id
  end
end
