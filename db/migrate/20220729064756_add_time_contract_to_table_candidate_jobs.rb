class AddTimeContractToTableCandidateJobs < ActiveRecord::Migration[7.0]
  def change
    add_column :candidate_jobs, :contract_start_at, :datetime
    add_column :candidate_jobs, :contract_end_at, :datetime
  end
end
