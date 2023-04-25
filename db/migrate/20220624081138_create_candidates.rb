# frozen_string_literal: true

class CreateCandidates < ActiveRecord::Migration[7.0]
  def change
    create_table :candidates do |t|
      t.references :user, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :first_name_kana, null: false
      t.string :last_name_kana, null: false
      t.integer :gender
      t.datetime :dob
      t.string :zipcode
      t.string :address
      t.string :phone_number
      t.text :experiences
      t.text :diplomas

      t.timestamps
    end
  end
end
