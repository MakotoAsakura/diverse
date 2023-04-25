class AddReadAtToCandidateJobs < ActiveRecord::Migration[7.0]
  def change
    add_column :candidate_jobs, :employee_read_at, :datetime
    add_column :candidate_jobs, :medical_read_at, :datetime
  end
end
