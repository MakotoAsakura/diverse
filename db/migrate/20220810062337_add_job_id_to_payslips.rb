class AddJobIdToPayslips < ActiveRecord::Migration[7.0]
  def change
    rename_column :payslips, :tax, :total_transportation_fee
    add_column :payslips, :job_id, :integer, after: :medical_institution_id
  end
end
