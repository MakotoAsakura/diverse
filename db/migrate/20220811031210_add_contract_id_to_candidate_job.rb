class AddContractIdToCandidateJob < ActiveRecord::Migration[7.0]
  def change
    add_column :candidate_jobs, :contract_id, :string
  end
end
