 class AddInfoToInvoice < ActiveRecord::Migration[7.0]
  def change
    add_column :invoices, :year, :integer, null: false
    add_column :invoices, :month, :integer, null: false
    add_column :invoices, :medical_institution_id, :integer, null: false
    add_column :invoices, :system_fee, :integer, comment: "in percent", null: false
    add_column :invoices, :subtotal, :decimal, precision: 9, scale: 2, null: false
    add_column :invoices, :tax, :float, comment: "in percent", null: false
    add_column :invoices, :tax_money, :decimal, precision: 9, scale: 2, null: false
    add_column :invoices, :total, :decimal, precision: 9, scale: 2, null: false
    add_column :invoices, :settlement_date, :datetime, null: false
    add_column :invoices, :payment_due_date, :datetime, null: false
  end
end
