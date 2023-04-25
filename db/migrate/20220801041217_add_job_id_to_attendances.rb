class AddJobIdToAttendances < ActiveRecord::Migration[7.0]
  def change
    add_reference :attendances, :job, null: false, after: :candidate_id
    add_index :attendances, [:candidate_id, :job_id]
  end
end
