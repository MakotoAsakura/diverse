class CreateReceipts < ActiveRecord::Migration[7.0]
  def change
    create_table :receipts do |t|
      t.integer :year, null: false
      t.integer :month, null: false
      t.integer :hourly_salary, null: false, default: 0
      t.float :time, null: false, default: 0
      t.integer :tax, null: false, default: 0
      t.references :candidate, foreign_key: true, null: false
      t.references :medical_institution, foreign_key: true, null: false

      t.timestamps
    end
  end
end
