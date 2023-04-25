# frozen_string_literal: true

class CreateMedicalInstitutions < ActiveRecord::Migration[7.0]
  def change
    create_table :medical_institutions do |t|
      t.references :user, null: false
      t.string :name, null: false
      t.string :name_kana, null: false
      t.string :url
      t.string :zipcode
      t.string :location
      t.string :phone_number
      t.string :first_name_manger
      t.string :last_name_manager
      t.string :first_name_kana_manger
      t.string :last_name_kana_manager

      t.timestamps
    end
  end
end
