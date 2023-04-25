class CreateCalculatePayslipRunners < ActiveRecord::Migration[7.0]
  def change
    create_table :calculate_payslip_runners do |t|
      t.datetime :start_at, default: DateTime.now, null: false
      t.datetime :end_at
      t.integer :status, default: 1, null: false

      t.timestamps
    end
  end
end
