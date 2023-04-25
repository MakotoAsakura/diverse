class UpdateCandidateJobColumns < ActiveRecord::Migration[7.0]
  def change
    add_column :candidate_jobs, :salary_detail, :integer
    add_column :candidate_jobs, :salary_details_according_to, :integer
    add_column :candidate_jobs, :including_transportation_allowance, :integer, default: 0, null: false
    add_column :candidate_jobs, :remark, :text
    remove_column :jobs, :salary_detail
    remove_column :jobs, :salary_details_according_to
  end
end
