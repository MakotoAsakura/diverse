class AddTypeToTaxWitholding < ActiveRecord::Migration[7.0]
  def change
    add_column :tax_withholdings, :kind, :integer
    change_column :tax_withholdings, :tax, :string
  end
end
