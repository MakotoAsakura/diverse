class ChangeNameColumnCandidateJobTable < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :candidate_jobs, column: :user_id
    rename_column :candidate_jobs, :user_id, :job_id
    add_foreign_key :candidate_jobs, :jobs, column: :job_id
  end
end
