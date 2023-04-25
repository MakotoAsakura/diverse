class AddTaxPersonAndTaxWithholdingToPayslips < ActiveRecord::Migration[7.0]
  def change
    add_column :payslips, :tax_withholding , :float, after: :total_transportation_fee, default: 0
    add_column :payslips, :personal_income_tax , :float, after: :total_transportation_fee, default: 0
  end
end
