# frozen_string_literal: true

class CreatePharmaceuticalCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :pharmaceutical_companies do |t|
      t.references :medical_institution, null: false
      t.string :name, null: false, index: true
      t.string :phone_number
      t.string :zipcode
      t.string :location
      t.string :staff_ms
      t.string :email

      t.timestamps
    end
  end
end
