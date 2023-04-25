# frozen_string_literal: true

class CreateBanks < ActiveRecord::Migration[7.0]
  def change
    create_table :banks do |t|
      t.references :candidate, null: false
      t.string :bank_name
      t.string :branch_name
      t.integer :account_type
      t.string :account_number
      t.string :account_holder_name

      t.timestamps
    end
  end
end
