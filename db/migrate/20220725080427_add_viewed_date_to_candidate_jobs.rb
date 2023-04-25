class AddViewedDateToCandidateJobs < ActiveRecord::Migration[7.0]
  def change
    add_column :candidate_jobs, :viewed_date, :datetime
  end
end
