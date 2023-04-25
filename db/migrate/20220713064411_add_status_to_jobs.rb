class AddStatusToJobs < ActiveRecord::Migration[7.0]
  def change
    add_column :jobs, :status, :integer, default: 0, null: false, after: :medical_institution_id
  end
end
