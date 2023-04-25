class CreateTaxWithholdings < ActiveRecord::Migration[7.0]
  def change
    create_table :tax_withholdings do |t|
      t.integer :from
      t.integer :to
      t.integer :tax

      t.timestamps
    end
  end
end
