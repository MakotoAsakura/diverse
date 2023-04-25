class RemoveValueDefaultStartAtCalculatePayslipRunners < ActiveRecord::Migration[7.0]
  def change
    change_column_default :calculate_payslip_runners, :start_at, nil
  end
end
