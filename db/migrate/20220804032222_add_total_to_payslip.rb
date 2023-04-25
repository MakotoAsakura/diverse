class AddTotalToPayslip < ActiveRecord::Migration[7.0]
  def change
    add_column :payslips, :total, :float, after: :month
    add_column :payslips, :salary_according_to, :integer, after: :tax, default: 0
    rename_column :payslips, :time, :total_hour
    change_column :payslips, :hourly_salary, :float
    rename_column :payslips, :hourly_salary, :unit_price
    add_column :payslips, :total_day, :float, after: :total_hour
  end
end
