class ChangeReceiptToPayslip < ActiveRecord::Migration[7.0]
  def change
    rename_table :receipts, :payslips
  end
end
