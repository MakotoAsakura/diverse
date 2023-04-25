class UpdateFieldTypePayslipsTable < ActiveRecord::Migration[7.0]
  def up
    change_column :payslips, :total, :decimal, precision: 15, scale: 2
    change_column :payslips, :unit_price, :decimal, precision: 15, scale: 2
    change_column :payslips, :total_hour, :decimal, precision: 15, scale: 2
    change_column :payslips, :total_day, :decimal, precision: 15, scale: 2
    change_column :payslips, :total_transportation_fee, :decimal, precision: 15, scale: 2
    change_column :payslips, :personal_income_tax, :decimal, precision: 15, scale: 2
    change_column :payslips, :tax_withholding, :decimal, precision: 15, scale: 2
    change_column :invoices, :tax, :decimal, precision: 15, scale: 2
  end

  def down
    change_column :payslips, :total, :float
    change_column :payslips, :unit_price, :float
    change_column :payslips, :total_hour, :float
    change_column :payslips, :total_day, :float
    change_column :payslips, :total_transportation_fee, :float
    change_column :payslips, :personal_income_tax, :float
    change_column :payslips, :tax_withholding, :float
    change_column :invoices, :tax, :float
  end
end
